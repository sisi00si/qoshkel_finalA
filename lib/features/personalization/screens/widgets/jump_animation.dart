import 'dart:math' as math;
import 'package:flutter/material.dart';

class JumpingBadge extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const JumpingBadge({super.key, required this.child, required this.delay});

  @override
  State<JumpingBadge> createState() => _JumpingBadgeState();
}

class _JumpingBadgeState extends State<JumpingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: math.pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Delay start
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final y = -17 * math.sin(_animation.value);
        return Transform.translate(
          offset: Offset(0, y),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
