import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show DocumentChangeType;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide navigator;
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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

  static const Map<String, dynamic> _rtcConfig = {
    'iceServers': [
      {
        'urls': [
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302',
        ]
      },
    ],
  };

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _appointmentId;
  bool _remoteDescriptionSet = false;

  StreamSubscription? _roomSubscription;
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
        ToastServices.warning('Call Disconnected', 'The connection was lost.');
        callStatusText.value = 'Disconnected';
      }
    };

    try {
      final role = await _videoCallRepo.joinOrCreateRoom(appointmentId);
      if (role == CallRole.caller) {
        await _startAsCaller(appointmentId);
      } else {
        await _joinAsCallee(appointmentId);
      }
    } catch (e) {
      isConnecting.value = false;
      ToastServices.error('Connection Error', e.toString());
    }
  }

  Future<void> _startAsCaller(String appointmentId) async {
    callStatusText.value = 'Waiting for the other participant...';

    _peerConnection!.onIceCandidate = (candidate) {
      _videoCallRepo.addOfferCandidate(appointmentId, candidate);
    };

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    await _videoCallRepo.sendOffer(appointmentId, offer);

    _roomSubscription = _videoCallRepo.roomStream(appointmentId).listen((snapshot) async {
      final data = snapshot.data();
      final answer = data?['answer'];
      if (answer != null && !_remoteDescriptionSet) {
        _remoteDescriptionSet = true;
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(answer['sdp'], answer['type']),
        );
      }
    });

    _answerCandidatesSubscription =
        _videoCallRepo.answerCandidatesStream(appointmentId).listen((snapshot) {
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

  Future<void> _joinAsCallee(String appointmentId) async {
    callStatusText.value = 'Joining call...';

    _peerConnection!.onIceCandidate = (candidate) {
      _videoCallRepo.addAnswerCandidate(appointmentId, candidate);
    };

    final offer = await _videoCallRepo.getOffer(appointmentId);
    if (offer == null) {
      ToastServices.error('Connection Error', 'No active call found to join.');
      isConnecting.value = false;
      return;
    }

    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );
    _remoteDescriptionSet = true;

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    await _videoCallRepo.sendAnswer(appointmentId, answer);

    _offerCandidatesSubscription =
        _videoCallRepo.offerCandidatesStream(appointmentId).listen((snapshot) {
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
    if (_appointmentId != null) {
      await _videoCallRepo.endCall(_appointmentId!);
    }
    await _cleanupMediaAndConnection();
    if (context.mounted) context.go(AppRoutes.appointment);
  }

  Future<void> _cleanupMediaAndConnection() async {
    await _roomSubscription?.cancel();
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
