// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;

    return Stack(
      children: [
        ///  Adaptive Blue Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [Color(0xFF0B1D2D), Color(0xFF102A43)]
                  : const [Color(0xFFEAF2FF), Color(0xFFF7FAFF)],
            ),
          ),
        ),

        ///  Decorative Blue Shapes (Top)
        Positioned(
          top: -140,
          left: -100,
          child: _SoftCircle(
            size: 280,
            color: isDark
                ? const Color(0xFF1F4FD8).withOpacity(0.12)
                : const Color(0xFF3B82F6).withOpacity(0.12),
          ),
        ),

        ///  Decorative Blue Shapes (Bottom)
        Positioned(
          bottom: -120,
          right: -90,
          child: _SoftCircle(
            size: 240,
            color: isDark
                ? const Color(0xFF60A5FA).withOpacity(0.08)
                : const Color(0xFF2563EB).withOpacity(0.10),
          ),
        ),

        ///  Content
        SafeArea(child: child),
      ],
    );
  }
}

/// Reusable Soft Circle
class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
