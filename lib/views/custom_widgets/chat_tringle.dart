import 'package:flutter/material.dart';

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-6, 0);
   // path.lineTo(0, 10);
    path.lineTo(0, -8);
    path.lineTo(6, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
} 

// In user bubble (example)
/* Transform(
  alignment: Alignment.center,
  transform: Matrix4.rotationY(math.pi), // flips for right-side triangle
  child: CustomPaint(
    size: const Size(10, 10),
    painter: Triangle(sendColor),
  ),
) */




/* class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    // Draw an upside-down triangle (flat top, point down)
    path.moveTo(0, 0);        // top center
    path.lineTo(-5, -10);     // top left
    path.lineTo(5, -10);      // top right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
 */
