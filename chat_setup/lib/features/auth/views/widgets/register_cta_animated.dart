import 'package:flutter/material.dart';

class RegisterCtaAnimated extends StatefulWidget {
  final VoidCallback onGoRegister;

  const RegisterCtaAnimated({super.key, required this.onGoRegister});

  @override
  State<RegisterCtaAnimated> createState() => _RegisterCtaAnimatedState();
}

class _RegisterCtaAnimatedState extends State<RegisterCtaAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onGoRegister();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _tap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            child: Text(
              'إنشاء حساب جديد',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
