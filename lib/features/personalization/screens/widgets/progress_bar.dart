import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress; // from 0.0 to 1.0
  final double height;
  final double radius;
  final Gradient gradient;

  const GradientProgressBar({
    Key? key,
    required this.progress,
    this.height = 12,
    this.radius = 50,
    required this.gradient,
  })  : assert(progress >= 0 && progress <= 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          // Background track
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          // Progress bar with gradient
          Container(
            width: width * progress,
            height: height,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ],
      );
    });
  }
}
