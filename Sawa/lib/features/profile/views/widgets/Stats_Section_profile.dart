// ignore_for_file: non_constant_identifier_names, deprecated_member_use, invalid_null_aware_operator, file_names

import 'package:chat_setup/features/profile/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = Get.find<UserController>().user.value;
      if (user == null) return const CircularProgressIndicator();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatColumn(label: 'Posts', value: user.postsCount.toString()),
          _StatColumn(
            label: 'Followers',
            value: user.followersCount.toString(),
          ),
          _StatColumn(
            label: 'Following',
            value: user.followingCount?.toString() ?? '0',
          ),
        ],
      );
    });
  }

  Widget _StatColumn({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
