import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyChatsView extends StatelessWidget {
  const EmptyChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 120),

            /// 🖼 No Chats Animation
            Lottie.asset(
              'assets/anim/No notification.json',
              height: 240,
              repeat: true,
            ),

            const SizedBox(height: 14),

            ///  Title
            const Text(
              'لا توجد محادثات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ///  Subtitle
            Text(
              'ابدأ أول محادثة الآن\nوتواصل مع أصدقائك بسهولة وسرعة.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.5, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
