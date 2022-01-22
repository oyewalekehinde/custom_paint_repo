import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SliderCustomWidget extends StatefulWidget {
  SliderCustomWidget({Key? key}) : super(key: key);

  @override
  _SliderCustomWidgetState createState() => _SliderCustomWidgetState();
}

class _SliderCustomWidgetState extends State<SliderCustomWidget> {
  double _controller = 0.0;
  double range = 200;
  int interval = 10;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.05,
        ),
        Container(
          height: 200,
          width: 200,
          child: CustomPaint(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notification_important, size: 50),
                    Text(
                      '${_controller.roundToDouble().toInt()}',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.water_sharp, size: 50),
                  ],
                ),
              ),
            ),
            painter: SliderCustomPaint(
              value: _controller * (360 / range),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.05,
        ),
        GestureDetector(
          onTap: () {
            Timer.periodic(Duration(seconds: 1), (Timer timer) {
              if (_controller < range) {
                setState(() {
                  _controller += interval;
                  if (_controller > range) {
                    _controller = range;
                    timer.cancel();
                  }
                });
              } else {
                timer.cancel();
              }
            });
          },
          child: Container(
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
        ),
        SizedBox(
          height: size.height * 0.1,
        ),
        Container(
          height: size.height * 0.1,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.01),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.wheelchair_pickup,
                    size: 25,
                  ),
                  Icon(
                    Icons.wheelchair_pickup,
                    size: 25,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "0℃",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onPanUpdate: (details) {
                      if ((details.localPosition.dx >= 0 &&
                              details.localPosition.dx <= 200) &&
                          !details.localPosition.dx.isNegative) {
                        setState(() {
                          _controller =
                              details.localPosition.dx * (range / 200);
                        });
                      }
                    },
                    child: Container(
                      height: 5,
                      width: 200,
                      child: CustomPaint(
                          painter: LinearSlider(
                              directionX: _controller * (200 / range))),
                    ),
                  ),
                  Text(
                    "$range℃",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
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

class LinearSlider extends CustomPainter {
  double directionX;
  LinearSlider({
    required this.directionX,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var startX = 0.0;
    var startY = size.height;
    var centerY = size.height / 2;
    var circleOffset = Offset(directionX, centerY);

    var endX = size.width;
    var linePaint = Paint()
      ..strokeWidth = startY
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var cicrlePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), linePaint);
    if (directionX >= 0.0 && directionX <= size.width) {
      canvas.drawLine(
          Offset(startX, centerY), Offset(directionX, centerY), cicrlePaint);
      canvas.drawCircle(circleOffset, 8, cicrlePaint);
    }
    if (directionX <= 0.0) {
      canvas.drawLine(Offset(startX, centerY), Offset(0, centerY), cicrlePaint);

      canvas.drawCircle(Offset(0, centerY), 8, cicrlePaint);
    }
    if (directionX >= size.width) {
      canvas.drawLine(
          Offset(startX, centerY), Offset(size.width, centerY), cicrlePaint);
      canvas.drawCircle(Offset(size.width, centerY), 8, cicrlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
