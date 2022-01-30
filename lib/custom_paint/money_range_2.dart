import 'dart:math';

import 'package:flutter/material.dart';

class MoneyRange extends StatefulWidget {
  MoneyRange({Key? key}) : super(key: key);

  @override
  _MoneyRangeState createState() => _MoneyRangeState();
}

class _MoneyRangeState extends State<MoneyRange> {
  double _controller = 0.0;
  double range = 200;
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
                      '${_controller.roundToDouble().toInt()}',
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
    var centerY = size.height / 2;
    var circleOffset = Offset(directionX, centerY);
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
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    var barPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green
      ..strokeWidth = 5;

    for (double i = 0; i <= directionX; i += 15) {
      canvas.drawRect(
          Rect.fromPoints(Offset(startX + i, centerY),
              Offset(startX + i + 10, (-i * 0.1) + 15)),
          barPaint);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(
                Offset(startX, centerY - 2), Offset(endX, (centerY + 2))),
            Radius.circular(5)),
        linePaint);

    if (directionX >= 0.0 && directionX <= size.width) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromPoints(
                  Offset(startX, centerY - 2), Offset(directionX, centerY + 2)),
              Radius.circular(5)),
          cicrlePaint);

      canvas.drawCircle(circleOffset, 15, cicrlePaint);
    }

    if (directionX <= 0.0) {
      canvas.drawCircle(Offset(0, centerY + 1), 8, cicrlePaint);
    }
    var triangle = Path();
    triangle.moveTo(directionX - 10, centerY);
    triangle.lineTo(directionX - 5, centerY - 5);
    triangle.lineTo(directionX - 5, centerY + 5);
    triangle.close();

    canvas.drawPath(triangle, linesPaint);
    var triangle2 = Path();
    triangle2.moveTo(directionX + 10, centerY);
    triangle2.lineTo(directionX + 5, centerY - 5);
    triangle2.lineTo(directionX + 5, centerY + 5);
    triangle2.close();

    canvas.drawPath(triangle2, linesPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
