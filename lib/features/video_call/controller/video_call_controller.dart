import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show DocumentChangeType;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide navigator;
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../utils/constants/local_storage_key_strings.dart';
import '../../../utils/dependency_locator.dart';
import '../../../utils/navigation/app_routes.dart';
import '../../../utils/networks/toast_services/toast_services.dart';
import '../repo/video_call_repo.dart';

class VideoCallController extends GetxController {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  final RxBool isMicOn = true.obs;
  final RxBool isCameraOn = true.obs;
  final RxBool isConnecting = true.obs;
  final RxBool permissionDenied = false.obs;
  final RxString callStatusText = 'Connecting...'.obs;

  final IVideoCallRepo _videoCallRepo = getIt();

  // STUN alone only works when both peers can find a direct P2P route; on
  // mobile data / restrictive NATs that fails silently (signaling succeeds,
  // onTrack fires, but no media ever arrives — a black remote video). TURN
  // relays media when a direct route isn't possible. OpenRelay's free public
  // TURN server is used here since this is a demo/test app, not production
  // traffic — see README "Known limitations" for the production alternative.
  static const Map<String, dynamic> _rtcConfig = {
    'iceServers': [
      {
        'urls': [
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302',
        ]
      },
      {
        'urls': 'turn:openrelay.metered.ca:80',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
      {
        'urls': 'turn:openrelay.metered.ca:443',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
      {
        'urls': 'turn:openrelay.metered.ca:443?transport=tcp',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
    ],
  };

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _appointmentId;
  String? _callId;
  bool _remoteDescriptionSet = false;
  bool _callEndHandled = false;

  StreamSubscription? _sessionSubscription;
  StreamSubscription? _offerCandidatesSubscription;
  StreamSubscription? _answerCandidatesSubscription;

  Future<void> initCall(String appointmentId) async {
    _appointmentId = appointmentId;

    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    if (!camera.isGranted || !mic.isGranted) {
      permissionDenied.value = true;
      isConnecting.value = false;
      ToastServices.warning(
        'Permission Required',
        'Camera and microphone access are required to start a video call.',
      );
      return;
    }

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });
    localRenderer.srcObject = _localStream;

    _peerConnection = await createPeerConnection(_rtcConfig);
    for (final track in _localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams.first;
        isConnecting.value = false;
        callStatusText.value = 'Connected';
      }
    };

    _peerConnection!.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        // Fallback for when the other side vanished without writing
        // status:'ended' (e.g. app killed, network dropped entirely) — the
        // Firestore session-status listener below is the fast/normal path.
        _handleCallEndedRemotely('The connection was lost.');
      }
    };

    try {
      final joinResult = await _videoCallRepo.joinOrCreateRoom(appointmentId);
      final callId = joinResult.callId;
      _callId = callId;

      // Every call attempt gets its own never-reused session document (see
      // VideoCallRepo docs), so this listener can never see leftover state
      // from a *previous* finished call — eliminating the whole class of
      // "brand-new call immediately looks ended" races earlier designs hit
      // when a single shared document was reset/reused across retries.
      //
      // Shared by both roles: the callee previously never listened for the
      // session ending at all, so it had no way of knowing when the caller
      // pressed End Call — it just sat frozen on the call screen.
      _sessionSubscription =
          _videoCallRepo.sessionStream(appointmentId, callId).listen((snapshot) async {
        final data = snapshot.data();
        if (data == null) return;

        if (data['status'] == 'ended') {
          _handleCallEndedRemotely('The other participant ended the call.');
          return;
        }

        // Caller-only: pick up the answer once the callee writes it.
        final answer = data['answer'];
        if (answer != null && !_remoteDescriptionSet && _peerConnection != null) {
          _remoteDescriptionSet = true;
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(answer['sdp'], answer['type']),
          );
        }
      });

      if (joinResult.role == CallRole.caller) {
        await _startAsCaller(appointmentId, callId);
      } else {
        await _joinAsCallee(appointmentId, callId);
      }
    } catch (e) {
      isConnecting.value = false;
      ToastServices.error('Connection Error', e.toString());
    }
  }

  Future<void> _startAsCaller(String appointmentId, String callId) async {
    callStatusText.value = 'Waiting for the other participant...';

    _peerConnection!.onIceCandidate = (candidate) {
      _videoCallRepo.addOfferCandidate(appointmentId, callId, candidate);
    };

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    await _videoCallRepo.sendOffer(appointmentId, callId, offer);

    _answerCandidatesSubscription =
        _videoCallRepo.answerCandidatesStream(appointmentId, callId).listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data()!;
          _peerConnection!.addCandidate(RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ));
        }
      }
    });
  }

  Future<void> _joinAsCallee(String appointmentId, String callId) async {
    callStatusText.value = 'Joining call...';

    _peerConnection!.onIceCandidate = (candidate) {
      _videoCallRepo.addAnswerCandidate(appointmentId, callId, candidate);
    };

    final offer = await _videoCallRepo.waitForOffer(appointmentId, callId);

    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );
    _remoteDescriptionSet = true;

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    await _videoCallRepo.sendAnswer(appointmentId, callId, answer);

    _offerCandidatesSubscription =
        _videoCallRepo.offerCandidatesStream(appointmentId, callId).listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data()!;
          _peerConnection!.addCandidate(RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ));
        }
      }
    });
  }

  void toggleMic() {
    final track = _localStream?.getAudioTracks().firstOrNull;
    if (track == null) return;
    track.enabled = !track.enabled;
    isMicOn.value = track.enabled;
  }

  void toggleCamera() {
    final track = _localStream?.getVideoTracks().firstOrNull;
    if (track == null) return;
    track.enabled = !track.enabled;
    isCameraOn.value = track.enabled;
  }

  Future<void> endCall(BuildContext context) async {
    // Set before the Firestore write so this device's own session listener
    // (which will see the status:'ended' it's about to write) doesn't also
    // treat it as a remote-initiated end.
    _callEndHandled = true;
    if (_appointmentId != null && _callId != null) {
      await _videoCallRepo.endCall(_appointmentId!, _callId!);
    }
    await _cleanupMediaAndConnection();
    if (context.mounted) context.go(AppRoutes.appointment);
  }

  /// The other participant ended the call (or the connection dropped) — mirror
  /// of [endCall] but triggered remotely, so there's no local BuildContext;
  /// navigation goes through the app's global navigator key instead.
  Future<void> _handleCallEndedRemotely(String message) async {
    if (_callEndHandled) return;
    _callEndHandled = true;

    ToastServices.warning('Call Ended', message);
    callStatusText.value = 'Disconnected';
    await _cleanupMediaAndConnection();

    final context = LocalStorageKeyStrings.appNavKey.currentContext;
    if (context != null && context.mounted) {
      context.go(AppRoutes.appointment);
    }
  }

  Future<void> _cleanupMediaAndConnection() async {
    await _sessionSubscription?.cancel();
    await _offerCandidatesSubscription?.cancel();
    await _answerCandidatesSubscription?.cancel();

    for (final track in _localStream?.getTracks() ?? <MediaStreamTrack>[]) {
      await track.stop();
    }
    await _localStream?.dispose();
    await _peerConnection?.close();
  }

  @override
  Future<void> onClose() async {
    await _cleanupMediaAndConnection();
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    super.onClose();
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
