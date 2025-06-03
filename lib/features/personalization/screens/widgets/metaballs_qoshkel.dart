import 'dart:math';
import 'package:flutter/material.dart';

class SimpleBallsScreen extends StatefulWidget {
  final int ballCount;

  const SimpleBallsScreen({super.key, this.ballCount = 30});

  @override
  State<SimpleBallsScreen> createState() => _SimpleBallsScreenState();
}

class _SimpleBallsScreenState extends State<SimpleBallsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Ball> balls = [];
  final double minRadius = 15;
  final double maxRadius = 40;
  final Random random = Random();

  Size containerSize = Size.zero;

  @override
  void initState() {
    super.initState();
    // Создадим шарики позже, когда узнаем размер контейнера
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    );
    _controller.addListener(_update);
    _controller.repeat();
  }

  void _initializeBalls() {
    balls.clear();
    for (int i = 0; i < widget.ballCount; i++) {
      balls.add(Ball(
        position: Offset(
          random.nextDouble() * (containerSize.width - maxRadius * 2) +
              maxRadius,
          random.nextDouble() * (containerSize.height - maxRadius * 2) +
              maxRadius,
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 200,
          (random.nextDouble() - 0.5) * 200,
        ),
        radius: minRadius + random.nextDouble() * (maxRadius - minRadius),
        color: Colors.blueAccent,
      ));
    }
  }

  void _update() {
    if (containerSize == Size.zero) return; // ждем размер

    setState(() {
      for (var ball in balls) {
        // Обновляем позицию
        ball.position += ball.velocity * 0.016; // ~60fps

        // Отталкиваем от границ контейнера
        if (ball.position.dx - ball.radius < 0 && ball.velocity.dx < 0) {
          ball.velocity = Offset(-ball.velocity.dx, ball.velocity.dy);
        }
        if (ball.position.dx + ball.radius > containerSize.width &&
            ball.velocity.dx > 0) {
          ball.velocity = Offset(-ball.velocity.dx, ball.velocity.dy);
        }
        if (ball.position.dy - ball.radius < 0 && ball.velocity.dy < 0) {
          ball.velocity = Offset(ball.velocity.dx, -ball.velocity.dy);
        }
        if (ball.position.dy + ball.radius > containerSize.height &&
            ball.velocity.dy > 0) {
          ball.velocity = Offset(ball.velocity.dx, -ball.velocity.dy);
        }

        // Простое сближение (отталкивание)
        for (var other in balls) {
          if (other == ball) continue;
          final dist = (other.position - ball.position).distance;
          final minDist = ball.radius + other.radius;
          if (dist < minDist && dist > 0) {
            final diff = (ball.position - other.position).normalize();
            ball.velocity += diff * 5;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (containerSize !=
            Size(constraints.maxWidth, constraints.maxHeight)) {
          containerSize = Size(constraints.maxWidth, constraints.maxHeight);
          _initializeBalls();
        }

        return CustomPaint(
          size: containerSize,
          painter: BallsPainter(balls),
        );
      },
    );
  }
}

class Ball {
  Offset position;
  Offset velocity;
  final double radius;
  final Color color;

  Ball({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });
}

class BallsPainter extends CustomPainter {
  final List<Ball> balls;

  BallsPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var ball in balls) {
      paint.color = ball.color;
      canvas.drawCircle(ball.position, ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BallsPainter oldDelegate) => true;
}

extension on Offset {
  Offset operator *(double operand) => Offset(dx * operand, dy * operand);
  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
  Offset operator -(Offset other) => Offset(dx - other.dx, dy - other.dy);

  Offset normalize() {
    final len = distance;
    if (len == 0) return const Offset(0, 0);
    return Offset(dx / len, dy / len);
  }
}
