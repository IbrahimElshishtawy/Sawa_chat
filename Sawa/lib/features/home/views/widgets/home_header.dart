// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/profile/controllers/user_controller.dart';
import '../../../../core/constants/app_colors.dart';
import 'quick_settings_sheet.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool searchMode = false;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 120.0,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final name = userCtrl.user.value?.name ?? 'Sphere';
                      return Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      );
                    }),
                    Row(
                      children: [
                        _iconBtn(
                          icon: Icons.search_rounded,
                          onTap: () {},
                        ),
                        _iconBtn(
                          icon: Icons.more_vert_rounded,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (_) => const QuickSettingsSheet(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final desc = userCtrl.user.value?.description ?? 'Premium Social Experience';
                  return Text(
                    desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(icon, size: 24),
      onPressed: onTap,
      splashRadius: 24,
    );
  }
}
