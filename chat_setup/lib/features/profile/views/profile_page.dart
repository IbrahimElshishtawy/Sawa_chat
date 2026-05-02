import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_setup/features/home/views/widgets/floating_nav_bar.dart';
import 'package:chat_setup/features/profile/views/widgets/Complete_Profile_Button.dart';
import 'package:chat_setup/features/profile/views/widgets/Contact_Button_profile.dart';
import 'package:chat_setup/features/profile/views/widgets/Description_user_profile.dart';
import 'package:chat_setup/features/profile/views/widgets/Profile_Picture_profile.dart';
import 'package:chat_setup/features/profile/views/widgets/Share_pprofile_Button.dart';
import 'package:chat_setup/features/profile/views/widgets/Stats_Section_profile.dart';
import 'package:chat_setup/features/profile/views/widgets/User_Info_profile.dart';
import 'package:chat_setup/features/profile/views/widgets/User_Posts_profile.dart';
import 'package:chat_setup/features/profile/views/widgets/profile_action_buttons.dart';

import 'package:chat_setup/features/profile/controllers/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final UserController userCtrl;

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController usernameCtrl;
  late TextEditingController descriptionCtrl;

  @override
  void initState() {
    super.initState();
    userCtrl = Get.find<UserController>();

    final user = userCtrl.user.value;
    nameCtrl = TextEditingController(text: user?.name ?? '');
    phoneCtrl = TextEditingController(text: user?.phone ?? '');
    usernameCtrl = TextEditingController(text: user?.username ?? '');
    descriptionCtrl = TextEditingController(text: user?.description ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    usernameCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/editProfile'),
          ),
        ],
      ),
      body: Obx(() {
        final user = userCtrl.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isProfileComplete =
            user.name.isNotEmpty &&
            user.phone != null &&
            user.username != null &&
            user.description != null &&
            user.profilePicture != null;

        return Stack(
          children: [
            /// 🔹 المحتوى
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// صورة + إحصائيات
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfilePicture(userCtrl: userCtrl),
                      const SizedBox(width: 16),
                      const Expanded(child: StatsSection()),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// 🔥 أزرار الصداقة / المتابعة / المراسلة
                  ProfileActionButtons(profileUserId: user.id),

                  const SizedBox(height: 24),

                  /// معلومات المستخدم
                  UserInfo(
                    nameCtrl: nameCtrl,
                    phoneCtrl: phoneCtrl,
                    usernameCtrl: usernameCtrl,
                  ),

                  const SizedBox(height: 16),

                  /// الوصف
                  DescriptionSection(descriptionCtrl: descriptionCtrl),

                  const SizedBox(height: 16),

                  /// استكمال البروفايل
                  if (!isProfileComplete) ...[
                    const CompleteProfileButton(),
                    const SizedBox(height: 16),
                  ],

                  /// مشاركة / تواصل
                  Row(
                    children: const [
                      Expanded(child: ShareButton()),
                      SizedBox(width: 16),
                      Expanded(child: ContactButton()),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// البوستات
                  Text(
                    'المنشورات',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  UserPostsWidget(userId: user.id),
                ],
              ),
            ),

            /// 🔹 Bottom Nav
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingNavBar(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
