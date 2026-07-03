// ignore_for_file: deprecated_member_use, file_names

import 'dart:io';
import 'package:chat_setup/features/profile/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.userCtrl});

  final UserController userCtrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          await userCtrl.updateProfilePicture(File(image.path));
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: userCtrl.user.value?.profilePicture != null
                  ? NetworkImage(userCtrl.user.value!.profilePicture!)
                  : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              child: userCtrl.user.value?.profilePicture == null
                  ? const Icon(Icons.camera_alt, color: Colors.white)
                  : null,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 24),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery, // تغيير الصورة
                );

                if (image != null) {
                  await userCtrl.updateProfilePicture(File(image.path));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
