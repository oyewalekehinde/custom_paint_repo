import 'package:flutter/material.dart';

class MoneyRange extends StatefulWidget {
  MoneyRange({Key? key}) : super(key: key);

  @override
  _MoneyRangeState createState() => _MoneyRangeState();
}

class _MoneyRangeState extends State<MoneyRange> {
  double _controller = 0.0; //this is the current value of the controller
  double range = 500; // this is the maximum value you want to get to

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
        SizedBox(
          height: size.height * 0.05,
        ),
        SizedBox(
          height: size.height * 0.1,
        ),
        Container(
          height: size.height * 0.2,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.01),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.6), width: 2),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Filter Card Rates",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Center(
                child: Text(
                  "₦ ${_controller.roundToDouble().toInt()}/\$", // this is the current value when been slide
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
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
              ),
              SizedBox(
                width: widthSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₦100/\$",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple),
                    ),
                    Text(
                      "₦$range/\$",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LinearSlider extends CustomPainter {
  double directionX;
  LinearSlider({
    required this.directionX,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var startX = 0.0;

    var centerY = size.height / 2;
    var circleOffset = Offset(directionX, centerY);
    var endX = size.width;
    var linePaint = Paint()
      ..color = Colors.purple.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    var cicrlePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 40
      ..color = Colors.purple
      ..strokeCap = StrokeCap.square;
    var linesPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    var barPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.purple.withOpacity(0.2)
      ..strokeWidth = 5;

//this is the bar, i use a for loop so as the get the number of loop when sliding
    for (double i = 0; i <= directionX; i += 15) {
      canvas.drawRect(
          Rect.fromPoints(Offset(startX + i, centerY),
              Offset(startX + i + 10, (-i * 0.1) + 15)),
          barPaint);
    }
    //the background line
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(
                Offset(startX, centerY - 2), Offset(endX, (centerY + 2))),
            Radius.circular(5)),
        linePaint);

    //this is the current slide position with the circle
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(
                Offset(startX, centerY - 2), Offset(directionX, centerY + 2)),
            Radius.circular(5)),
        cicrlePaint);

    canvas.drawCircle(circleOffset, 15, cicrlePaint);

// the small triangle in the purple circle
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
