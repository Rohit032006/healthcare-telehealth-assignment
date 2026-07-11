import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum CallRole { caller, callee }

class RoomJoinResult {
  final CallRole role;
  final String callId;

  const RoomJoinResult({required this.role, required this.callId});
}

abstract class IVideoCallRepo {
  /// Atomically decides whether this app instance is the caller or callee
  /// for [appointmentId], and hands back a [RoomJoinResult.callId] that
  /// uniquely identifies *this* call attempt.
  ///
  /// Every attempt gets its own never-reused Firestore subdocument rather
  /// than repeatedly resetting/deleting one shared document — earlier
  /// designs that reused a single doc across retries kept hitting races
  /// where a fresh call attempt would misread leftover fields from the
  /// previous (already finished) call. A brand-new document per attempt
  /// makes that category of bug structurally impossible: there is never
  /// anything stale to misread.
  Future<RoomJoinResult> joinOrCreateRoom(String appointmentId);

  Future<void> sendOffer(String appointmentId, String callId, RTCSessionDescription offer);
  Future<void> sendAnswer(String appointmentId, String callId, RTCSessionDescription answer);

  /// Waits (listens) until the caller's offer appears, rather than checking
  /// once — the caller may still be creating its offer (an async WebRTC
  /// call) when the callee reaches this point.
  Future<Map<String, dynamic>> waitForOffer(String appointmentId, String callId);

  Stream<DocumentSnapshot<Map<String, dynamic>>> sessionStream(String appointmentId, String callId);

  Future<void> addOfferCandidate(String appointmentId, String callId, RTCIceCandidate candidate);
  Future<void> addAnswerCandidate(String appointmentId, String callId, RTCIceCandidate candidate);

  Stream<QuerySnapshot<Map<String, dynamic>>> offerCandidatesStream(String appointmentId, String callId);
  Stream<QuerySnapshot<Map<String, dynamic>>> answerCandidatesStream(String appointmentId, String callId);

  Future<void> endCall(String appointmentId, String callId);
}

/// Firestore is used purely as a signaling channel to exchange the SDP
/// offer/answer and ICE candidates between two peers — all actual audio/video
/// media flows peer-to-peer via WebRTC, never through Firestore.
class VideoCallRepo implements IVideoCallRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _pointer(String appointmentId) =>
      _firestore.collection('calls').doc(appointmentId);

  DocumentReference<Map<String, dynamic>> _session(String appointmentId, String callId) =>
      _pointer(appointmentId).collection('sessions').doc(callId);

  @override
  Future<RoomJoinResult> joinOrCreateRoom(String appointmentId) async {
    final pointerRef = _pointer(appointmentId);

    return _firestore.runTransaction<RoomJoinResult>((tx) async {
      final snap = await tx.get(pointerRef);
      final data = snap.data();
      final activeCallId = data?['activeCallId'] as String?;
      final status = data?['status'];

      if (activeCallId != null && status == 'waiting') {
        // Someone is actively waiting for a callee right now — join them,
        // and flip status immediately so a third instance can't also claim
        // callee for the same session.
        tx.set(pointerRef, {'status': 'answered'}, SetOptions(merge: true));
        return RoomJoinResult(role: CallRole.callee, callId: activeCallId);
      }

      // No one is waiting (a brand-new appointment, a call that already
      // completed, or one that was abandoned) — claim a fresh session.
      final newCallId = pointerRef.collection('sessions').doc().id;
      tx.set(pointerRef, {
        'activeCallId': newCallId,
        'status': 'waiting',
      });
      return RoomJoinResult(role: CallRole.caller, callId: newCallId);
    });
  }

  @override
  Future<void> sendOffer(String appointmentId, String callId, RTCSessionDescription offer) {
    return _session(appointmentId, callId).set({
      'status': 'active',
      'offer': {'sdp': offer.sdp, 'type': offer.type},
    }, SetOptions(merge: true));
  }

  @override
  Future<void> sendAnswer(String appointmentId, String callId, RTCSessionDescription answer) {
    return _session(appointmentId, callId).set({
      'status': 'active',
      'answer': {'sdp': answer.sdp, 'type': answer.type},
    }, SetOptions(merge: true));
  }

  @override
  Future<Map<String, dynamic>> waitForOffer(String appointmentId, String callId) async {
    final snap = await _session(appointmentId, callId)
        .snapshots()
        .firstWhere((s) => s.data()?['offer'] != null)
        .timeout(const Duration(seconds: 30));
    return Map<String, dynamic>.from(snap.data()!['offer'] as Map);
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> sessionStream(String appointmentId, String callId) {
    return _session(appointmentId, callId).snapshots();
  }

  @override
  Future<void> addOfferCandidate(String appointmentId, String callId, RTCIceCandidate candidate) {
    return _session(appointmentId, callId).collection('offerCandidates').add(candidate.toMap());
  }

  @override
  Future<void> addAnswerCandidate(String appointmentId, String callId, RTCIceCandidate candidate) {
    return _session(appointmentId, callId).collection('answerCandidates').add(candidate.toMap());
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> offerCandidatesStream(String appointmentId, String callId) {
    return _session(appointmentId, callId).collection('offerCandidates').snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> answerCandidatesStream(String appointmentId, String callId) {
    return _session(appointmentId, callId).collection('answerCandidates').snapshots();
  }

  @override
  Future<void> endCall(String appointmentId, String callId) {
    return _session(appointmentId, callId).set({'status': 'ended'}, SetOptions(merge: true));
  }
}
