// ignore_for_file: file_names

import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String text;
  const EmptyCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100,
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
