import 'package:flutter/material.dart';

class MultiSegmentCircularIndicator extends StatelessWidget {
  final double completedPercent;   // e.g., 0.5
  final double inProgressPercent; // e.g., 0.3
  final double notStartedPercent; // e.g., 0.2

  const MultiSegmentCircularIndicator({
    super.key,
    required this.completedPercent,
    required this.inProgressPercent,
    required this.notStartedPercent,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(140, 140),
      painter: _SegmentPainter(
        completedPercent,
        inProgressPercent,
        notStartedPercent,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "145",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "hours",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentPainter extends CustomPainter {
  final double completed;
  final double inProgress;
  final double notStarted;

  _SegmentPainter(this.completed, this.inProgress, this.notStarted);

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -90.0;
    double strokeWidth = 12.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final completedAngle = 360 * completed;
    final inProgressAngle = 360 * inProgress;
    final notStartedAngle = 360 * notStarted;

    // Draw completed
    final completedPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _degToRad(startAngle), _degToRad(completedAngle), false, completedPaint);
    startAngle += completedAngle;

    // Draw in progress
    final inProgressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _degToRad(startAngle), _degToRad(inProgressAngle), false, inProgressPaint);
    startAngle += inProgressAngle;

    // Draw not started
    final notStartedPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _degToRad(startAngle), _degToRad(notStartedAngle), false, notStartedPaint);
  }

  double _degToRad(double degree) => degree * (3.14159265359 / 180.0);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
