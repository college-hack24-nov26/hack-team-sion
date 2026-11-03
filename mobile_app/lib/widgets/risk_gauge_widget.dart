import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme.dart';

class RiskGaugeWidget extends StatelessWidget {
  final double score;
  final String status;
  final double size;

  const RiskGaugeWidget({
    super.key,
    required this.score,
    required this.status,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = RakshanTheme.getRiskColor(score);
    final riskBgColor = RakshanTheme.getRiskBgColor(score);
    final riskLabel = RakshanTheme.getRiskLabel(score);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size * 0.72,
              child: CustomPaint(
                painter: _GaugePainter(
                  value: animatedValue,
                  color: riskColor,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        animatedValue.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: size * 0.22,
                          fontWeight: FontWeight.w900,
                          color: RakshanTheme.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'RISK INDEX (0–100)',
                        style: TextStyle(
                          fontSize: size * 0.055,
                          fontWeight: FontWeight.w700,
                          color: RakshanTheme.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: riskBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: riskColor.withOpacity(0.35), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: riskColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: riskColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: riskColor.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    riskLabel,
                    style: TextStyle(
                      color: riskColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.42;
    const strokeWidth = 14.0;

    const startAngle = math.pi * 0.85;
    const totalSweep = math.pi * 1.30;

    // Light theme slate background track
    final trackPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      trackPaint,
    );

    // Active progress arc with bright gradient
    final sweep = (value / 100.0) * totalSweep;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          RakshanTheme.safeGreen,
          RakshanTheme.warningAmber,
          RakshanTheme.criticalRed,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
