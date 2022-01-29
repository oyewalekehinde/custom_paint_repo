import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SliderRangeWidget extends StatefulWidget {
  SliderRangeWidget({Key? key}) : super(key: key);

  @override
  _SliderRangeWidgetState createState() => _SliderRangeWidgetState();
}

class _SliderRangeWidgetState extends State<SliderRangeWidget> {
  double _controller = 0.0;
  double range = 100000;
  int interval = 10;
  late double widthSize;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    widthSize = size.width * 0.75;
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
                    Text(
                      '₦${(_controller ~/ 1000) * 1000.toInt()}',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
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
        // GestureDetector(
        //   onTap: () {
        //     Timer.periodic(Duration(seconds: 1), (Timer timer) {
        //       if (_controller < range) {
        //         setState(() {
        //           _controller += interval;
        //           if (_controller > range) {
        //             _controller = range;
        //             timer.cancel();
        //           }
        //         });
        //       } else {
        //         timer.cancel();
        //       }
        //     });
        //   },
        //   child: Container(
        //     height: 100,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.red,
        //     ),
        //     child: Icon(
        //       Icons.power_settings_new,
        //       size: 50,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: size.height * 0.1,
        ),
        Container(
          height: size.height * 0.15,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is your budget per night",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: widthSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "From ₦5,000",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "₦100,000",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onPanUpdate: (details) {
                      if ((details.localPosition.dx >= 0 &&
                              details.localPosition.dx <= widthSize) &&
                          !details.localPosition.dx.isNegative) {
                        setState(() {
                          _controller =
                              details.localPosition.dx * (range / widthSize);
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: widthSize,
                      child: CustomPaint(
                          painter: LinearSlider(
                              directionX: _controller * (widthSize / range))),
                    ),
                  ),
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

    var endX = size.width;
    var linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    var cicrlePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 40
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square;
    var linesPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2;

//this is the background rectangle

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(Offset(startX, 0), Offset(endX, startY)),
            Radius.circular(5)),
        linePaint);

    // current rectangle scrolling

    if (directionX > 31) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromPoints(Offset(startX, 0), Offset(directionX, startY)),
              Radius.circular(5)),
          cicrlePaint);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(Offset(startX, 0), Offset(30, startY)),
            Radius.circular(5)),
        cicrlePaint);

    // this is first three lines
    canvas.drawLine(Offset(10, 10), Offset(10, startY - 10), linesPaint);
    canvas.drawLine(Offset(15, 15), Offset(15, startY - 15), linesPaint);
    canvas.drawLine(Offset(20, 10), Offset(20, startY - 10), linesPaint);

    //this is the last three lines
    if (directionX > 45) {
      canvas.drawLine(Offset(directionX - 10, 10),
          Offset(directionX - 10, startY - 10), linesPaint);
      canvas.drawLine(Offset(directionX - 15, 15),
          Offset(directionX - 15, startY - 15), linesPaint);
      canvas.drawLine(Offset(directionX - 20, 10),
          Offset(directionX - 20, startY - 10), linesPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
