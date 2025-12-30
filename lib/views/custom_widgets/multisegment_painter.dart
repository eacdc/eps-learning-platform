import 'package:flutter/material.dart';

class MultiSegmentCircle extends StatelessWidget {
  final double completedPercent;
  final double inProgressPercent;
  final double notStartedPercent;
  final num totalHoursSpent;

  final Color completedColor;
  final Color inProgressColor;
  final Color notStartedColor;

  const MultiSegmentCircle({
    super.key,
    required this.completedPercent,
    required this.inProgressPercent,
    required this.notStartedPercent,
    required this.totalHoursSpent,
    required this.completedColor,
    required this.inProgressColor,
    required this.notStartedColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: MultiSegmentPainter(
        completedPercent: completedPercent,
        inProgressPercent: inProgressPercent,
        notStartedPercent: notStartedPercent,
        completedColor: completedColor,
        inProgressColor: inProgressColor,
        notStartedColor: notStartedColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text(
             totalHoursSpent.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class MultiSegmentPainter extends CustomPainter {
  final double completedPercent;
  final double inProgressPercent;
  final double notStartedPercent;
  final Color completedColor;
  final Color inProgressColor;
  final Color notStartedColor;

  MultiSegmentPainter({
    required this.completedPercent,
    required this.inProgressPercent,
    required this.notStartedPercent,
      required this.completedColor,
    required this.inProgressColor,
    required this.notStartedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -90 * 3.1416 / 180; // Start from top

    // Completed
    paint.color = completedColor;
    final completedSweep = 2 * 3.1416 * completedPercent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      completedSweep,
      false,
      paint,
    );

    // In Progress
    startAngle += completedSweep;
    paint.color = inProgressColor;
    final inProgressSweep = 2 * 3.1416 * inProgressPercent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      inProgressSweep,
      false,
      paint,
    );

    // Not Started
    startAngle += inProgressSweep;
    paint.color = notStartedColor;
    final notStartedSweep = 2 * 3.1416 * notStartedPercent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      notStartedSweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
