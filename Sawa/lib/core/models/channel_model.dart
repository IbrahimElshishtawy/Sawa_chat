import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final List<String> admins;
  final int subscribersCount;
  final bool isPublic;
  final DateTime createdAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChannelModel({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    required this.admins,
    this.subscribersCount = 0,
    this.isPublic = true,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'admins': admins,
      'subscribersCount': subscribersCount,
      'isPublic': isPublic,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory ChannelModel.fromMap(String id, Map<String, dynamic> map) {
    return ChannelModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'],
      ownerId: map['ownerId'] ?? '',
      admins: List<String>.from(map['admins'] ?? []),
      subscribersCount: map['subscribersCount'] ?? 0,
      isPublic: map['isPublic'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }
}
