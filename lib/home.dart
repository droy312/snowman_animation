import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const Color bgBlue = Color.fromRGBO(153, 217, 234, 1);
  static const Color bgWhite = Color.fromRGBO(249, 249, 249, 1);
  static const Color white = Colors.white;
  static const Color orange = Colors.orange;
  static const Color black = Colors.black;
  static const Color brown = Colors.brown;

  AnimationController a, a2;
  Random random = Random();

  static Widget snowFlake(double size) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: white,
          shape: BoxShape.circle,
        ),
      );

  List<Offset> snowFlakesOffset;
  List<Widget> snowFlakes;

  void snowOffset() {}

  @override
  void initState() {
    super.initState();

    snowFlakesOffset = List.generate(
        100, (index) => Offset(random.nextDouble(), random.nextDouble()));
    snowFlakes =
        List.generate(100, (index) => snowFlake(5 + (random.nextDouble() * 5)));

    a = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 18000));
    a.forward();
    a.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        a.repeat();
      }
    });

    a2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    a2.forward();
    a2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        a2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        a2.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgBlue,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              color: bgWhite,
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 360) / 2,
            left: (MediaQuery.of(context).size.width - 200) / 2,
            child: AnimatedBuilder(
              animation: a2,
              builder: (context, child) {
                final double value = a2.value;
                return CustomPaint(
                  size: Size(200, 360),
                  painter: Snowman(value: value),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              child: AnimatedBuilder(
                animation: a,
                builder: (context, child) {
                  final double value = a.value;
                  return Row(
                    children: snowFlakesOffset.asMap().entries.map((e) {
                      return Transform.translate(
                        offset: Offset(
                            e.value.dx * (deviceWidth),
                            (-(deviceHeight + 400) * e.value.dy) +
                                (value * deviceHeight)),
                        child: snowFlakes[e.key],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Snowman extends CustomPainter {
  final double value;
  const Snowman({this.value});

  static const Color white = Colors.white;
  static const Color orange = Colors.orange;
  static const Color black = Colors.black;
  static const Color brown = Colors.brown;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bodyPaint = Paint()..color = white;
    final Paint eyePaint = Paint()..color = black;
    final Paint nosePaint = Paint()..color = orange;
    final Paint handPaint = Paint()
      ..color = brown
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final double headSize = size.width * .40;
    final double bodySize = size.width * .80;

    final double x1 = size.width / 2 - (headSize * .70);
    final double y1 = headSize * .50;
    final Path nosePath = Path()
      ..addPolygon(
          [Offset(x1, (-5 * value) + y1 + 5), Offset(x1 + 50, (-5 * value) + y1), Offset(x1 + 50, (-5 * value) + y1 + 10)],
          true);

    canvas.drawCircle(
        Offset(size.width / 2, (-5 * value) + (headSize / 2)), headSize / 2, bodyPaint);
    canvas.drawCircle(Offset(size.width / 2, (size.height - headSize) / 2),
        bodySize / 2, bodyPaint);
    canvas.drawPath(nosePath, nosePaint);
    canvas.drawCircle(
        Offset(size.width / 2 - (headSize * .25), (-5 * value) + headSize * .30), 6, eyePaint);
    canvas.drawCircle(
        Offset(size.width / 2 + (headSize * .10), (-5 * value) + headSize * .30), 6, eyePaint);
    canvas.drawLine(
        Offset(0 + (5 * value), (10 * value) + headSize + bodySize * .10),
        Offset(bodySize * .30, headSize + bodySize * .20),
        handPaint);
    canvas.drawLine(
        Offset((5 * value) + bodySize * .80,
            (10 * value) + headSize + bodySize * .05),
        Offset(bodySize * .70, headSize + bodySize * .20),
        handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
