import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AnalogClock extends StatelessWidget {
  const AnalogClock({
    super.key,
    required this.time,
    this.size = 300,
    this.isDarkMode = true,
  });

  final DateTime time;
  final double size;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PremiumClockPainter(time: time, isDarkMode: isDarkMode),
      ),
    );
  }
}

class _PremiumClockPainter extends CustomPainter {
  _PremiumClockPainter({required this.time, required this.isDarkMode});

  final DateTime time;
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final glowColor = isDarkMode ? AppColors.clockGlowDark : AppColors.clockGlowLight;
    final faceColor = isDarkMode ? const Color(0xFF18181B) : const Color(0xFFFAFAFA);
    final borderColor = glowColor;
    final hourColor = isDarkMode ? const Color(0xFFF4F4F5) : const Color(0xFF18181B);
    final minuteColor = isDarkMode ? const Color(0xFFA1A1AA) : const Color(0xFF52525B);
    const secondColor = Color(0xFFEF4444);

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [glowColor.withValues(alpha: 0.35), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.95));
    canvas.drawCircle(center, radius * 0.92, glowPaint);

    // Face gradient
    final facePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: isDarkMode
            ? [const Color(0xFF27272A), faceColor]
            : [Colors.white, const Color(0xFFE4E4E7)],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.86));
    canvas.drawCircle(center, radius * 0.86, facePaint);

    // Border ring
    final borderPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.025;
    canvas.drawCircle(center, radius * 0.88, borderPaint);

    // Inner ring
    final innerRing = Paint()
      ..color = borderColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.008;
    canvas.drawCircle(center, radius * 0.78, innerRing);

    // Tick marks
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * pi / 180 - pi / 2;
      final isHour = i % 5 == 0;
      final tickLen = isHour ? radius * 0.1 : radius * 0.04;
      final tickW = isHour ? radius * 0.022 : radius * 0.01;

      final outer = Offset(
        center.dx + cos(angle) * radius * 0.76,
        center.dy + sin(angle) * radius * 0.76,
      );
      final inner = Offset(
        center.dx + cos(angle) * (radius * 0.76 - tickLen),
        center.dy + sin(angle) * (radius * 0.76 - tickLen),
      );

      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = isHour ? borderColor : borderColor.withValues(alpha: 0.35)
          ..strokeWidth = tickW
          ..strokeCap = StrokeCap.round,
      );
    }

    // Hour numbers
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30) * pi / 180 - pi / 2;
      final pos = Offset(
        center.dx + cos(angle) * radius * 0.58,
        center.dy + sin(angle) * radius * 0.58,
      );
      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(
          color: hourColor,
          fontSize: radius * 0.12,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2));
    }

    final secondAngle = (time.second * 6) * pi / 180 - pi / 2;
    final minuteAngle = (time.minute * 6 + time.second * 0.1) * pi / 180 - pi / 2;
    final hourAngle = (time.hour % 12 * 30 + time.minute * 0.5) * pi / 180 - pi / 2;

    _drawHand(canvas, center, hourAngle, radius * 0.42, radius * 0.05, hourColor, true);
    _drawHand(canvas, center, minuteAngle, radius * 0.62, radius * 0.035, minuteColor, true);
    _drawHand(canvas, center, secondAngle, radius * 0.7, radius * 0.012, secondColor, false, counter: radius * 0.14);

    // Center cap
    canvas.drawCircle(
      center,
      radius * 0.07,
      Paint()
        ..shader = RadialGradient(colors: [borderColor, borderColor.withValues(alpha: 0.6)])
            .createShader(Rect.fromCircle(center: center, radius: radius * 0.07)),
    );
    canvas.drawCircle(center, radius * 0.035, Paint()..color = secondColor);
  }

  void _drawHand(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    double width,
    Color color,
    bool shadow, {
    double counter = 0,
  }) {
    if (shadow) {
      final shadowEnd = Offset(center.dx + cos(angle) * length + 2, center.dy + sin(angle) * length + 2);
      canvas.drawLine(
        center + const Offset(2, 2),
        shadowEnd,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.25)
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    final end = Offset(center.dx + cos(angle) * length, center.dy + sin(angle) * length);
    canvas.drawLine(
      center,
      end,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );

    if (counter > 0) {
      final counterEnd = Offset(
        center.dx + cos(angle + pi) * counter,
        center.dy + sin(angle + pi) * counter,
      );
      canvas.drawLine(center, counterEnd, Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumClockPainter old) =>
      old.time != time || old.isDarkMode != isDarkMode;
}
