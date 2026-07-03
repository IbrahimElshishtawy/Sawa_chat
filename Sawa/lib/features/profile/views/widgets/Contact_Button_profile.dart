// =====================
// Contact Button Widget
// =====================
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ContactButton extends StatelessWidget {
  const ContactButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Implement Contact functionality here
        },
        child: const Text('Contact'),
      ),
    );
  }
}
