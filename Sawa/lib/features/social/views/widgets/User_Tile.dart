// ignore_for_file: deprecated_member_use, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userId;
  final Widget trailing;
  final String? subtitleOverride;

  const UserTile({
    super.key,
    required this.userId,
    required this.trailing,
    this.subtitleOverride,
  });

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId).get(),
      builder: (_, snap) {
        final data = snap.data?.data() as Map<String, dynamic>?;

        final name = (data?['name'] ?? 'مستخدم') as String;
        final username = (data?['username'] ?? '') as String;
        final photo = data?['profilePicture'] as String?;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
            boxShadow: [
              if (Theme.of(context).brightness != Brightness.dark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
            ],
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: (photo != null && photo.isNotEmpty)
                    ? NetworkImage(photo)
                    : null,
                child: (photo == null || photo.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitleOverride ??
                          (username.isEmpty ? '' : '@$username'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              trailing,
            ],
          ),
        );
      },
    );
  }
}
