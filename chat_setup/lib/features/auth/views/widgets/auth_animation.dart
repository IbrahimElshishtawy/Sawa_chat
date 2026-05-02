import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthAnimation extends StatelessWidget {
  final String asset;
  final double height;

  const AuthAnimation({super.key, required this.asset, this.height = 230});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      height: height,
      repeat: true,
      fit: BoxFit.contain,
    );
  }
}
