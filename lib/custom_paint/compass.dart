import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassWidget extends StatefulWidget {
  CompassWidget({Key? key}) : super(key: key);

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  final children = <Widget>[];
  double angle = 0;
  @override
  Widget build(BuildContext context) {
    return
        // Transform.rotate(
        //   angle: -pi / 2,
        //   child:
        Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<CompassEvent>(
            stream: FlutterCompass.events,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error reading heading: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              double? direction = snapshot.data!.heading;

              // if direction is null, then device does not support this sensor
              // show error message
              if (direction == null)
                return Center(
                  child: Text("Device does not have sensors !"),
                );
              return Column(
                children: [
                  SizedBox(
                    height: 130,
                  ),
                  Transform.rotate(
                    angle: 0,
                    child: Container(
                      height: 300,
                      width: 300,
                      child: CustomPaint(
                        painter: CompassPainter(direction: direction),
                      ),
                      // ),
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                  ),
                  Text(
                    "${direction.toInt()}°" + getDirection(direction),
                    style: TextStyle(
                        fontSize: 70,
                        color: Colors.white,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "6°34\'50\" N  3°24\'2\" E",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Lagos, Nigeria",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "0 m Elevation",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              );
            }),
      ],
    );
  }
}

class CompassPainter extends CustomPainter {
  double direction = 0;
  CompassPainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var centerCircle = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var borderCicrle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    var innerColor = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    var borderCicrleThick = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    var compassLine = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    var trianglePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    var outerCicrle = radius;
    var innerCicrle = radius - 16;
    var tRadius = radius + 30;
    var tRadiusDirection = radius - 40;
    var tRadiusTriangle = radius + 7.5;
    canvas.drawCircle(centerCircle, radius / 3, innerColor);
    canvas.drawLine(Offset(centerX, centerY - size.height / 4),
        Offset(centerX, centerY + size.height / 4), borderCicrle);

    canvas.drawLine(Offset(centerX - size.width / 4, centerY),
        Offset(centerX + size.width / 4, centerY), borderCicrle);

    // canvas.drawLine(Offset(centerX + size.width / 2, centerY),
    //     Offset(centerX + size.width / 1.5, centerY), compassLine);
    for (int i = 0; i <= 360; i += 2) {
      var x1 = centerX + outerCicrle * cos(i * pi / 180);
      var y1 = centerX + outerCicrle * sin(i * pi / 180);
      var x2 = centerX + innerCicrle * cos(i * pi / 180);
      var y2 = centerX + innerCicrle * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), borderCicrle);
    }

    for (int i = 0; i <= 360; i += 30) {
      var x1 = centerX + outerCicrle * cos(i * pi / 180);
      var y1 = centerX + outerCicrle * sin(i * pi / 180);
      var x2 = centerX + innerCicrle * cos(i * pi / 180);
      var y2 = centerX + innerCicrle * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), borderCicrleThick);
    }
    for (int i = 0; i <= 360; i += 30) {
      var x1 = centerX + outerCicrle * cos(i * pi / 180);
      var y1 = centerX + outerCicrle * sin(i * pi / 180);
      var x2 = centerX + innerCicrle * cos(i * pi / 180);
      var y2 = centerX + innerCicrle * sin(i * pi / 180);
      var tx = centerX + tRadius * cos(i * pi / 180);
      var ty = centerX + tRadius * sin(i * pi / 180);
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 15,
      );
      final textSpan = TextSpan(
        text: i == 360 ? '' : '$i',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.rtl,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), borderCicrleThick);

      canvas.save();
      final pivot = textPainter.size.center(
          Offset(tx - textPainter.width / 2, ty - textPainter.height / 2));
      canvas.translate(pivot.dx, pivot.dy);
      canvas.rotate(pi / 2);
      canvas.translate(-pivot.dx, -pivot.dy);

      textPainter.paint(canvas,
          Offset(tx - textPainter.width / 2, ty - textPainter.height / 2));
      canvas.restore();
    }
    canvas.drawCircle(
        centerCircle,
        tRadiusTriangle,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    canvas.drawLine(
        centerCircle,
        Offset(centerX + tRadiusTriangle * cos(direction * pi / 180),
            centerY + tRadiusTriangle * sin(direction * pi / 180)),
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    for (int i = 0; i <= 360; i += 90) {
      var tx = centerX + tRadiusDirection * cos(i * pi / 180);
      var ty = centerX + tRadiusDirection * sin(i * pi / 180);
      var txTriangle = centerX + tRadiusTriangle * cos(direction * pi / 180);
      var tyTriangle = centerX + tRadiusTriangle * sin(direction * pi / 180);
      final textStyle = TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);

      final textSpan = TextSpan(
        text: i == 90
            ? 'E'
            : i == 180
                ? 'S'
                : i == 270
                    ? 'W'
                    : 'N',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      var trianglePath = Path();
      trianglePath.moveTo(txTriangle, tyTriangle - 10);
      trianglePath.lineTo(txTriangle + 10, tyTriangle);
      trianglePath.lineTo(txTriangle, tyTriangle + 10);
      trianglePath.close();

      if (i == 0) canvas.drawPath(trianglePath, trianglePaint);
      canvas.drawLine(Offset(txTriangle, tyTriangle - 40),
          Offset(txTriangle, tyTriangle + 40), Paint()..color = Colors.white);
      canvas.save();
      final pivot = textPainter.size.center(
          Offset(tx - textPainter.width / 2, ty - textPainter.height / 2));
      canvas.translate(pivot.dx, pivot.dy);
      canvas.rotate(pi / 2);
      canvas.translate(-pivot.dx, -pivot.dy);

      textPainter.paint(canvas,
          Offset(tx - textPainter.width / 2, ty - textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

String getDirection(double angle) {
  if (angle >= 0 && angle < 22) {
    return 'N';
  } else if (angle >= 22 && angle < 68) {
    return 'NE';
  } else if (angle >= 68 && angle < 112) {
    return 'E';
  } else if (angle >= 112 && angle < 156) {
    return 'SE';
  } else if (angle >= 156 && angle < 202) {
    return 'S';
  } else if (angle >= 202 && angle < 247) {
    return 'SW';
  } else if (angle >= 247 && angle < 292) {
    return 'W';
  } else if (angle >= 292 && angle < 337) {
    return 'NW';
  }

  return 'N';
}
