import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var piePaint1 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    var piePaint2 = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    var piePaint3 = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

// DIMENSION OF THE FIRST PIE

    final pie1 = Path();
    pie1.moveTo(200, 200);
    pie1.lineTo(190, 100);
    pie1.moveTo(200, 200);
    pie1.lineTo(220, 300);
    pie1.arcToPoint(Offset(190, 100),
        radius: Radius.circular(100), clockwise: false);
    pie1.close();

// DIMENSION OF THE SECOND PIE

    final pie2 = Path();
    pie2.moveTo(200, 200);
    pie2.lineTo(190, 100);
    pie2.moveTo(200, 200);
    pie2.lineTo(105, 160);
    pie2.arcToPoint(
      Offset(190, 100),
      radius: Radius.circular(100),
    );
    pie2.close();

// DIMENSION OF THE THIRD PIE

    final pie3 = Path();
    pie3.moveTo(200, 200);
    pie3.lineTo(105, 160);
    pie3.moveTo(200, 200);
    pie3.lineTo(220, 300);
    pie3.arcToPoint(
      Offset(105, 160),
      radius: Radius.circular(100),
    );
    pie3.close();

    canvas.drawPath(pie1, piePaint1);
    canvas.drawPath(pie2, piePaint2);
    canvas.drawPath(pie3, piePaint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
