import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TypingStatusText extends StatelessWidget {
  final String myId;
  final String otherUserId;

  const TypingStatusText({
    super.key,
    required this.myId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .snapshots(),
      builder: (_, snap) {
        if (!snap.hasData) return const SizedBox();

        final data = snap.data!.data() as Map<String, dynamic>;
        final typingTo = data['typingTo'];

        if (typingTo == myId) {
          return const Text(
            'يكتب الآن…',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          );
        }

        return const SizedBox();
      },
    );
  }
}
