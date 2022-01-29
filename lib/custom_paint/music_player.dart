import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: MusicPlayerPainter(),
      ),
    );
  }
}

class MusicPlayerPainter extends CustomPainter {
  final List<int> height = List.generate(73, (index) => Random().nextInt(50));

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = min(centerX, centerY);
    var circlePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    var linePaint = Paint()
      ..strokeWidth = 4
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var circleCenter = Offset(centerX, centerY);

    var outerCicrle = radius;
    var innerCicrle = radius;

    for (int i = 0; i <= 360; i += 5) {
      int currentHeight = height[i ~/ 5];
      var x1 = centerX + outerCicrle * cos(i * pi / 180);
      var y1 = centerX + outerCicrle * sin(i * pi / 180);
      var x2 = centerX + (innerCicrle + currentHeight) * cos(i * pi / 180);
      var y2 = centerX + (innerCicrle + currentHeight) * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }
    // canvas.drawCircle(circleCenter, radius, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
