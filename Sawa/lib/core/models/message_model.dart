import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final String? mediaUrl;
  final String? mediaType; // 'image', 'video', 'file', 'voice'
  final String senderId;
  final String senderName;
  final String receiverId;
  final DateTime createdAt;

  final bool isSeen;
  final DateTime? seenAt;
  final bool isDelivered;
  final DateTime? deliveredAt;

  /// تعديل
  final bool isEdited;
  final DateTime? editedAt;
  final int editCount;
  final DateTime? canEditUntil;

  final bool isDeleted; // delete for everyone
  final List<String> deletedFor; // delete for me (list of user IDs)

  final bool isForwarded;
  final bool isReported;

  /// ↩ رد
  final String? replyToMessageId;
  final String? replyToText;

  ///  React
  final Map<String, String>? reactions;
  // userId : emoji

  MessageModel({
    required this.id,
    required this.text,
    this.mediaUrl,
    this.mediaType,
    required this.senderId,
    this.senderName = '',
    required this.receiverId,
    required this.createdAt,
    required this.isSeen,
    this.seenAt,
    this.isDelivered = false,
    this.deliveredAt,
    this.isEdited = false,
    this.editedAt,
    this.editCount = 0,
    this.canEditUntil,
    this.isDeleted = false,
    this.deletedFor = const [],
    this.isForwarded = false,
    this.isReported = false,
    this.replyToMessageId,
    this.replyToText,
    this.reactions,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'isSeen': isSeen,
      'seenAt': seenAt,
      'isDelivered': isDelivered,
      'deliveredAt': deliveredAt,
      'isEdited': isEdited,
      'editedAt': editedAt,
      'editCount': editCount,
      'canEditUntil': canEditUntil,
      'isDeleted': isDeleted,
      'deletedFor': deletedFor,
      'isForwarded': isForwarded,
      'isReported': isReported,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
      'reactions': reactions ?? {},
    };
  }

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      text: map['text'] ?? '',
      mediaUrl: map['mediaUrl'],
      mediaType: map['mediaType'],
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isSeen: map['isSeen'] ?? false,
      seenAt: map['seenAt'] != null
          ? (map['seenAt'] as Timestamp).toDate()
          : null,
      isDelivered: map['isDelivered'] ?? false,
      deliveredAt: map['deliveredAt'] != null
          ? (map['deliveredAt'] as Timestamp).toDate()
          : null,
      isEdited: map['isEdited'] ?? false,
      editedAt: map['editedAt'] != null
          ? (map['editedAt'] as Timestamp).toDate()
          : null,
      editCount: map['editCount'] ?? 0,
      canEditUntil: map['canEditUntil'] != null
          ? (map['canEditUntil'] as Timestamp).toDate()
          : null,
      isDeleted: map['isDeleted'] ?? false,
      deletedFor: List<String>.from(map['deletedFor'] ?? []),
      isForwarded: map['isForwarded'] ?? false,
      isReported: map['isReported'] ?? false,
      replyToMessageId: map['replyToMessageId'],
      replyToText: map['replyToText'],
      reactions: Map<String, String>.from(map['reactions'] ?? {}),
    );
  }
}
