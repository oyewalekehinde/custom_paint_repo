import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SliderCustomWidget extends StatefulWidget {
  SliderCustomWidget({Key? key}) : super(key: key);

  @override
  _SliderCustomWidgetState createState() => _SliderCustomWidgetState();
}

class _SliderCustomWidgetState extends State<SliderCustomWidget> {
  int _value = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_value < 360) {
        setState(() {
          _value += 1;
        });
      } else {
        timer.cancel();
      }
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          child: Container(
            // color: Colors.red,
            height: 300,
            width: 300,
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.notification_important, size: 100),
                  Text(
                    '$_value',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.water_sharp, size: 100),
                ],
              ),
            ),
          ),
          painter: SliderCustomPaint(
            value: _value,
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Icon(
            Icons.power_settings_new,
            size: 50,
            color: Colors.white,
          ),
        ),
        Container(
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.wheelchair_pickup),
                  Icon(Icons.wheelchair_pickup)
                ],
              ),
              GestureDetector(
                onPanStart: (details) => print('pan start'),
                onPanEnd: (details) => print('pan end'),
                onPanUpdate: (details) => print(details.localPosition.dx),

                // onHorizontalDragStart: (details) => print(details),
                child: Container(
                  height: 20,
                  width: 200,
                  color: Colors.green,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class SliderCustomPaint extends CustomPainter {
  final num? value;

  SliderCustomPaint({this.value});
  @override
  void paint(Canvas canvas, Size size) {
    var centreX = size.width / 2;
    var centreY = size.height / 2;
    var center = Offset(centreX, centreY);
    var smallRadius = min(centreX, centreY);
    var bigRadius = smallRadius + 10;
    var smallCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    var bigCirclePaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    var arcPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, bigRadius, bigCirclePaint);
    canvas.drawCircle(center, smallRadius, smallCirclePaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: bigRadius), -pi / 2,
        (value! * pi / 180), false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
