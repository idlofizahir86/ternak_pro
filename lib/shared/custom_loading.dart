import 'package:flutter/material.dart';

class TernakProBoxLoading extends StatefulWidget {
  const TernakProBoxLoading({super.key});

  @override
  State<TernakProBoxLoading> createState() => _TernakProBoxLoadingState();
}

class _TernakProBoxLoadingState extends State<TernakProBoxLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final gradient = const LinearGradient(colors: [Color(0xFF298FBB), Color(0xFF0EBCB1)]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Box animasi keliling
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(200, 60),
                painter: BoxPathPainter(_controller.value),
              );
            },
          ),

          // Teks gradasi
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return gradient.createShader(
                Rect.fromLTWH(
                  bounds.width * _controller.value,
                  0,
                  bounds.width,
                  bounds.height,
                ),
              );
            },
            blendMode: BlendMode.srcIn,
            child: const Text(
              'TernakPro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoxPathPainter extends CustomPainter {
  final double progress;

  BoxPathPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - 10,
      height: size.height - 10,
    );

    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final path = Path()..addRRect(rRect);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Color(0xFF298FBB);

    final totalLength = path.computeMetrics().fold<double>(
      0.0,
      (sum, metric) => sum + metric.length,
    );

    final currentLength = totalLength * progress;

    for (final metric in path.computeMetrics()) {
      final extractLength = currentLength % metric.length;
      final dashLength = 40.0;
      final segment = metric.extractPath(
        extractLength,
        (extractLength + dashLength).clamp(0, metric.length),
      );
      canvas.drawPath(segment, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BoxPathPainter oldDelegate) =>
      oldDelegate.progress != progress;
}