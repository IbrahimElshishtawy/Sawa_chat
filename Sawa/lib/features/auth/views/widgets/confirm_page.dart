import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmPage extends StatelessWidget {
  final VoidCallback onDone;

  const ConfirmPage({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), onDone);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/anim/Confirm.json',
          repeat: false,
          width: 180,
        ),
      ),
    );
  }
}
