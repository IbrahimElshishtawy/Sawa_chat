import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/profile/controllers/user_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final nameCtrl = TextEditingController(
      text: userCtrl.user.value?.name ?? '',
    );
    final phoneCtrl = TextEditingController(
      text: userCtrl.user.value?.phone ?? '',
    );
    final descriptionCtrl = TextEditingController(
      text: userCtrl.user.value?.description ?? '',
    );
    final usernameCtrl = TextEditingController(
      text: userCtrl.user.value?.username ?? '',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: descriptionCtrl,
              maxLength: 70,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await userCtrl.updateProfile(
                    nameCtrl.text.trim(),
                    phoneCtrl.text.trim(),
                  );
                  Get.snackbar('Success', 'Profile updated');
                  Get.back(); // العودة إلى صفحة الملف الشخصي
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
