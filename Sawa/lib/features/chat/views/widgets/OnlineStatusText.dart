// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnlineStatusText extends StatelessWidget {
  final String userId;
  const OnlineStatusText({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('presence').doc(userId);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ref.snapshots(),
      builder: (_, snap) {
        if (!snap.hasData || snap.data?.data() == null) {
          return const Text('غير معروف', style: TextStyle(fontSize: 12));
        }

        final data = snap.data!.data()!;
        final isOnline = (data['isOnline'] ?? false) as bool;

        if (isOnline) {
          return const Text('متصل الآن', style: TextStyle(fontSize: 12));
        }

        // آخر ظهور
        final ts = data['lastSeen'];
        if (ts is! Timestamp) {
          return const Text('غير متصل', style: TextStyle(fontSize: 12));
        }

        final last = ts.toDate();
        return Text(
          'آخر ظهور: ${last.hour.toString().padLeft(2, '0')}:${last.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12),
        );
      },
    );
  }
}
