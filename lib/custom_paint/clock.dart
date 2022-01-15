import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPaint(),
    );
  }
}

class ClockPaint extends CustomPainter {
  var currentTime = DateTime.now();
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    final outerCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final innerCircle = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    final centerCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final outerDash = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final secondsHand = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final minutesHand = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final hoursHand = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 40, innerCircle);
    canvas.drawCircle(center, radius - 40, outerCircle);

    var hourHandX = centerX +
        60 * cos((currentTime.hour * 30 + currentTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX +
        60 * sin((currentTime.hour * 30 + currentTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hoursHand);

    var minHandX = centerX +
        80 *
            cos((currentTime.minute * 6 + currentTime.second * 0.1) * pi / 180);
    var minHandY = centerX +
        80 *
            sin((currentTime.minute * 6 + currentTime.second * 0.1) * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minutesHand);

    var secHandX = centerX + 80 * cos(currentTime.second * 6 * pi / 180);
    var secHandY = centerX + 80 * sin(currentTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secondsHand);
    canvas.drawCircle(center, 16, centerCircle);
    var outerCicrle = radius;
    var innerCicrle = radius - 14;
    for (int i = 0; i <= 360; i += 30) {
      var x1 = centerX + outerCicrle * cos(i * pi / 180);
      var y1 = centerX + outerCicrle * sin(i * pi / 180);
      var x2 = centerX + innerCicrle * cos(i * pi / 180);
      var y2 = centerX + innerCicrle * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), outerDash);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
