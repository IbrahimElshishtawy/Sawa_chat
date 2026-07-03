import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String description;
  final String groupIcon;
  final String createdBy;
  final List<String> admins;
  final List<String> members;
  final DateTime createdAt;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isPrivate;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.groupIcon,
    required this.createdBy,
    required this.admins,
    required this.members,
    required this.createdAt,
    this.lastMessage = '',
    this.lastMessageTime,
    this.isPrivate = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'groupIcon': groupIcon,
      'createdBy': createdBy,
      'admins': admins,
      'members': members,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isPrivate': isPrivate,
    };
  }

  factory GroupModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      groupIcon: map['groupIcon'] ?? '',
      createdBy: map['createdBy'] ?? '',
      admins: List<String>.from(map['admins'] ?? []),
      members: List<String>.from(map['members'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
      isPrivate: map['isPrivate'] ?? false,
    );
  }
}
