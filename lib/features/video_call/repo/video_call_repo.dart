import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum CallRole { caller, callee }

abstract class IVideoCallRepo {
  /// Atomically decides whether this app instance is the caller or callee
  /// for [appointmentId]'s call room, so two independent instances tapping
  /// "Start Video Call" at roughly the same time never collide.
  Future<CallRole> joinOrCreateRoom(String appointmentId);

  Future<void> sendOffer(String appointmentId, RTCSessionDescription offer);
  Future<void> sendAnswer(String appointmentId, RTCSessionDescription answer);
  Future<Map<String, dynamic>?> getOffer(String appointmentId);

  Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(String appointmentId);

  Future<void> addOfferCandidate(String appointmentId, RTCIceCandidate candidate);
  Future<void> addAnswerCandidate(String appointmentId, RTCIceCandidate candidate);

  Stream<QuerySnapshot<Map<String, dynamic>>> offerCandidatesStream(String appointmentId);
  Stream<QuerySnapshot<Map<String, dynamic>>> answerCandidatesStream(String appointmentId);

  Future<void> endCall(String appointmentId);
}

/// Firestore is used purely as a signaling channel to exchange the SDP
/// offer/answer and ICE candidates between two peers — all actual audio/video
/// media flows peer-to-peer via WebRTC, never through Firestore.
class VideoCallRepo implements IVideoCallRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _calls => _firestore.collection('calls');

  @override
  Future<CallRole> joinOrCreateRoom(String appointmentId) async {
    final ref = _calls.doc(appointmentId);
    bool wasStaleRoom = false;

    final role = await _firestore.runTransaction<CallRole>((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data();

      if (!snap.exists || data?['offer'] == null) {
        tx.set(ref, {
          'status': 'waiting',
          'createdAt': FieldValue.serverTimestamp(),
        });
        return CallRole.caller;
      }

      if (data?['answer'] == null) {
        return CallRole.callee;
      }

      // Both offer & answer already present — a stale room from a previous
      // test call. A plain (non-merge) set() below fully overwrites the
      // document, so offer/answer are already dropped just by omitting them
      // — FieldValue.delete() must not be used here, it's only valid with
      // update() or a merge set(), and throws [cloud_firestore/unknown] null
      // otherwise.
      wasStaleRoom = true;
      tx.set(ref, {
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return CallRole.caller;
    });

    // Old ICE candidates left over from the previous call would otherwise be
    // replayed into the new peer connection (a fresh listener sees every
    // pre-existing subcollection doc as "added").
    if (wasStaleRoom) {
      await _clearCandidates(ref, 'offerCandidates');
      await _clearCandidates(ref, 'answerCandidates');
    }

    return role;
  }

  Future<void> _clearCandidates(DocumentReference ref, String subcollection) async {
    final docs = await ref.collection(subcollection).get();
    final batch = _firestore.batch();
    for (final doc in docs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> sendOffer(String appointmentId, RTCSessionDescription offer) {
    return _calls.doc(appointmentId).set({
      'status': 'active',
      'offer': {'sdp': offer.sdp, 'type': offer.type},
    }, SetOptions(merge: true));
  }

  @override
  Future<void> sendAnswer(String appointmentId, RTCSessionDescription answer) {
    return _calls.doc(appointmentId).set({
      'status': 'active',
      'answer': {'sdp': answer.sdp, 'type': answer.type},
    }, SetOptions(merge: true));
  }

  @override
  Future<Map<String, dynamic>?> getOffer(String appointmentId) async {
    final snap = await _calls.doc(appointmentId).get();
    final offer = snap.data()?['offer'];
    return offer == null ? null : Map<String, dynamic>.from(offer as Map);
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(String appointmentId) {
    return _calls.doc(appointmentId).snapshots();
  }

  @override
  Future<void> addOfferCandidate(String appointmentId, RTCIceCandidate candidate) {
    return _calls.doc(appointmentId).collection('offerCandidates').add(candidate.toMap());
  }

  @override
  Future<void> addAnswerCandidate(String appointmentId, RTCIceCandidate candidate) {
    return _calls.doc(appointmentId).collection('answerCandidates').add(candidate.toMap());
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> offerCandidatesStream(String appointmentId) {
    return _calls.doc(appointmentId).collection('offerCandidates').snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> answerCandidatesStream(String appointmentId) {
    return _calls.doc(appointmentId).collection('answerCandidates').snapshots();
  }

  @override
  Future<void> endCall(String appointmentId) {
    return _calls.doc(appointmentId).set({'status': 'ended'}, SetOptions(merge: true));
  }
}
