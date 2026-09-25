import 'package:flutter/material.dart';
import '../models/models.dart';

Color statusColor(BpStatus status) {
  switch (status) {
    case BpStatus.normal:
      return const Color(0xFF2F8F5B);
    case BpStatus.elevated:
      return const Color(0xFFCE8A1E);
    case BpStatus.high:
      return const Color(0xFFC0392B);
  }
}

/// Line chart for the systolic BP trend, color-coded by status per point —
/// hand-painted so segment colors can change along the line, which
/// off-the-shelf chart widgets make awkward.
class BpTrendChart extends StatelessWidget {
  final List<BpPoint> points;
  final double height;

  const BpTrendChart({super.key, required this.points, this.height = 160});

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _BpChartPainter(points: points, labelColor: onSurfaceVariant)),
    );
  }
}

class _BpChartPainter extends CustomPainter {
  final List<BpPoint> points;
  final Color labelColor;

  _BpChartPainter({required this.points, required this.labelColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const leftPad = 8.0;
    const rightPad = 8.0;
    const topPad = 10.0;
    const bottomPad = 26.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final values = points.map((p) => p.systolic).toList();
    final minV = (values.reduce((a, b) => a < b ? a : b) - 10).floorToDouble();
    final maxV = (values.reduce((a, b) => a > b ? a : b) + 10).ceilToDouble();

    double xFor(int i) => leftPad + (points.length == 1 ? 0 : chartWidth * i / (points.length - 1));
    double yFor(double v) => topPad + chartHeight * (1 - (v - minV) / (maxV - minV));

    // Gridlines
    final gridPaint = Paint()
      ..color = labelColor.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (var i = 0; i <= 2; i++) {
      final y = topPad + chartHeight * i / 2;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - rightPad, y), gridPaint);
    }

    // Line segments, colored by the *ending* point's status.
    for (var i = 0; i < points.length - 1; i++) {
      final p1 = Offset(xFor(i), yFor(points[i].systolic));
      final p2 = Offset(xFor(i + 1), yFor(points[i + 1].systolic));
      final segmentPaint = Paint()
        ..color = statusColor(points[i + 1].status)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p1, p2, segmentPaint);
    }

    // Points + month labels.
    final textPainterBuilder = (String text, Color color) => TextPainter(
          text: TextSpan(text: text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          textDirection: TextDirection.ltr,
        )..layout();

    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final center = Offset(xFor(i), yFor(p.systolic));
      final dotPaint = Paint()..color = statusColor(p.status);
      canvas.drawCircle(center, 4, dotPaint);
      canvas.drawCircle(center, 4, Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);

      final label = textPainterBuilder(p.monthLabel, labelColor);
      label.paint(canvas, Offset(center.dx - label.width / 2, size.height - bottomPad + 8));
    }
  }

  @override
  bool shouldRepaint(covariant _BpChartPainter oldDelegate) => oldDelegate.points != points;
}
