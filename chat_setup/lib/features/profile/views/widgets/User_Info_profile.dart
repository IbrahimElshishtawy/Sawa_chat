// =====================
// User Info Widget
// =====================
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.usernameCtrl,
  });

  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController usernameCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Name'),
          enabled: false,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneCtrl,
          decoration: const InputDecoration(labelText: 'Phone Number'),
          enabled: false,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: usernameCtrl,
          decoration: const InputDecoration(labelText: 'Username'),
          enabled: false,
        ),
      ],
    );
  }
}
