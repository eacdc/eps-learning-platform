    import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DottedLinePainter extends CustomPainter {
      @override
      void paint(Canvas canvas, Size size) {
        var paint = Paint()
          ..color = Colors.grey
          ..strokeWidth = 1.0;

        double startX = 0;
        double dashWidth = 5;
        double dashSpace = 5;

        while (startX < size.width) {
          canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
          startX += dashWidth + dashSpace;
        }
      }

      @override
      bool shouldRepaint(covariant CustomPainter oldDelegate) {
        return false;
      }
    }