// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/social/views/Friend_Page.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(opacity: value, child: child),
          );
        },
        child: FloatingActionButton(
          heroTag: 'new_chat_fab',
          elevation: 8,
          backgroundColor: isDark
              ? Colors.blue.shade400
              : Theme.of(context).primaryColor,
          splashColor: Colors.white.withOpacity(0.25),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            size: 26,
            color: Colors.white,
          ),
          onPressed: () {
            Get.bottomSheet(
              const FriendPage(),
              isScrollControlled: true,
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
            );
          },
        ),
      ),
    );
  }
}
