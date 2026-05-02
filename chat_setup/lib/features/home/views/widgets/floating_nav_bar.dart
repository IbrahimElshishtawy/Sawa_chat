// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/core_features/controllers/navigation_controller.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController());

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final index = nav.index.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.chat_bubble_rounded,
              label: 'الدردشات',
              selected: index == 0,
              onTap: () => nav.change(0),
            ),
            _NavItem(
              icon: Icons.group_rounded,
              label: 'الجروبات',
              selected: index == 1,
              onTap: () => nav.change(1),
            ),
            _NavItem(
              icon: Icons.public_rounded,
              label: 'المجتمع',
              selected: index == 2,
              onTap: () => nav.change(2),
            ),
            _NavItem(
              icon: Icons.notifications_rounded,
              label: 'التنبيهات',
              selected: index == 3,
              onTap: () => nav.change(3),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'الملف',
              selected: index == 4,
              onTap: () => nav.change(4),
            ),
          ],
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected
                    ? primary.withOpacity(0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected ? primary : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? primary : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: selected ? 18 : 0,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
