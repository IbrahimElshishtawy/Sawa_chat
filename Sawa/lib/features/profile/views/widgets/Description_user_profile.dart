// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.descriptionCtrl});

  final TextEditingController descriptionCtrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // عرض الوصف بتنسيق قابل للتوسع
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Text(
                descriptionCtrl.text.isEmpty
                    ? "No description available"
                    : descriptionCtrl.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
