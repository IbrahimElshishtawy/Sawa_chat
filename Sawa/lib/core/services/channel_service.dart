import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/channel_model.dart';
import '../models/message_model.dart';

class ChannelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _channels => _firestore.collection('channels');

  Future<void> createChannel(ChannelModel channel) async {
    await _channels.doc(channel.id).set(channel.toMap());
  }

  Stream<List<ChannelModel>> getChannels() {
    return _channels.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ChannelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> sendChannelMessage({
    required String channelId,
    required MessageModel message,
  }) async {
    final channelRef = _channels.doc(channelId);

    await channelRef.update({
      'lastMessage': message.text,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    });

    await channelRef.collection('messages').add(message.toMap());
  }

  Stream<QuerySnapshot> getChannelMessages(String channelId) {
    return _channels
        .doc(channelId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 🔔 Subscribe
  Future<void> subscribeToChannel(String channelId, String userId) async {
    final batch = _firestore.batch();

    batch.set(
      _channels.doc(channelId).collection('subscribers').doc(userId),
      {'timestamp': FieldValue.serverTimestamp()},
    );

    batch.update(_channels.doc(channelId), {
      'subscribersCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// 🔕 Unsubscribe
  Future<void> unsubscribeFromChannel(String channelId, String userId) async {
    final batch = _firestore.batch();

    batch.delete(
      _channels.doc(channelId).collection('subscribers').doc(userId),
    );

    batch.update(_channels.doc(channelId), {
      'subscribersCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  /// 🔍 Is Subscribed
  Future<bool> isSubscribed(String channelId, String userId) async {
    final doc = await _channels
        .doc(channelId)
        .collection('subscribers')
        .doc(userId)
        .get();
    return doc.exists;
  }

  /// 👑 Add Admin
  Future<void> addChannelAdmin(String channelId, String userId) async {
    await _channels.doc(channelId).update({
      'admins': FieldValue.arrayUnion([userId]),
    });
  }

  /// 👨‍💼 Remove Admin
  Future<void> removeChannelAdmin(String channelId, String userId) async {
    await _channels.doc(channelId).update({
      'admins': FieldValue.arrayRemove([userId]),
    });
  }

  /// 📝 Update Channel Info
  Future<void> updateChannelInfo(String channelId, Map<String, dynamic> data) async {
    await _channels.doc(channelId).update(data);
  }

  /// ❌ Delete Channel
  Future<void> deleteChannel(String channelId) async {
    await _channels.doc(channelId).delete();
  }
}
