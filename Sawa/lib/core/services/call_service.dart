import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_model.dart';

class CallService {
  final _firestore = FirebaseFirestore.instance;
  final _calls = FirebaseFirestore.instance.collection('calls');
  CollectionReference calls() => _firestore.collection('calls');

  Future<void> startCall(CallModel call) async {
    await _calls.doc(call.callId).set(call.toMap());
    await calls().doc(call.callId).set({
      'callId': call.callId,
      'callerId': call.callerId,
      'receiverId': call.receiverId,
      'channelName': call.channelName,
      'type': call.type.name,
      'status': call.status.name,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> listenIncomingCalls(String uid) {
    return calls()
        .where('receiverId', isEqualTo: uid)
        .where('status', isEqualTo: CallStatus.ringing.name)
        .snapshots();
  }

  Future<void> updateCallStatus(String callId, CallStatus status) async {
    await calls().doc(callId).update({'status': status.name});
  }

  Future<void> updateStatus(String callId, CallStatus status) async {
    await _calls.doc(callId).update({'status': status.name});
  }

  Future<void> endCall(String callId) async {
    await updateStatus(callId, CallStatus.ended);
  }

  Future<void> rejectCall(String callId) async {
    await updateStatus(callId, CallStatus.rejected);
  }

  Stream<List<CallModel>> callHistory(String uid) {
    return _calls
        .where(
          Filter.or(
            Filter('callerId', isEqualTo: uid),
            Filter('receiverId', isEqualTo: uid),
          ),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => CallModel.fromMap(d.data())).toList());
  }
}
