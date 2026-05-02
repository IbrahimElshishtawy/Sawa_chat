
import 'package:chat_setup/core/models/channel_model.dart';
import 'package:chat_setup/core/models/message_model.dart';
import 'package:chat_setup/core/services/channel_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChannelController extends GetxController {
  final ChannelService _service = ChannelService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<void> createChannel(String name, String description) async {
    final myId = uid;
    if (myId == null) return;


    // If we want auto-generated ID:
    final docRef = FirebaseFirestore.instance.collection('channels').doc();
    final newChannel = ChannelModel(
      id: docRef.id,
      name: name,
      description: description,
      ownerId: myId,
      admins: [myId],
      createdAt: DateTime.now(),
    );

    await _service.createChannel(newChannel);
  }

  Stream<List<ChannelModel>> get allChannels => _service.getChannels();

  Future<void> sendChannelMessage(String channelId, String text) async {
    final myId = uid;
    if (myId == null) return;

    final message = MessageModel(
      id: '', 
      text: text,
      senderId: myId,
      createdAt: DateTime.now(),
      isSeen: false, 
      receiverId: channelId,
    );

    await _service.sendChannelMessage(channelId: channelId, message: message);
  }

  Stream<QuerySnapshot> getChannelMessages(String channelId) =>
      _service.getChannelMessages(channelId);

  Future<void> subscribe(String channelId) async {
    final myId = uid;
    if (myId == null) return;
    await _service.subscribeToChannel(channelId, myId);
  }

  Future<void> unsubscribe(String channelId) async {
    final myId = uid;
    if (myId == null) return;
    await _service.unsubscribeFromChannel(channelId, myId);
  }

  Future<bool> isSubscribed(String channelId) async {
    final myId = uid;
    if (myId == null) return false;
    return await _service.isSubscribed(channelId, myId);
  }
}
