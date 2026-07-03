// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SmallBtn extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const SmallBtn({
    super.key,
    required this.label,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}
