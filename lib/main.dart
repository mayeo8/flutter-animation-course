import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Polygon extends CustomPainter {
  final int sides;

  Polygon({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);
    final angle = (2 * pi) / sides;

    final angles = List.generate(sides, (index) => index * angle);
    final radius = size.width / 2;
    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );
    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygon && oldDelegate.sides != sides;
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController sidesController;
  late AnimationController radiusController;
  late AnimationController rotationController;
  late Animation<int> sidesAnimation;
  late Animation radiusAnimation;
  late Animation rotationAnimation;

  @override
  void initState() {
    super.initState();
    sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    sidesAnimation = IntTween(
      begin: 3,
      end: 10,
    ).animate(sidesController);
    radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    radiusAnimation = Tween(begin: 20.0, end: 400.0)
        .chain(
          CurveTween(curve: Curves.bounceInOut),
        )
        .animate(radiusController);
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    rotationAnimation = Tween(
      begin: 0.0,
      end: 2 * pi,
    )
        .chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        )
        .animate(rotationController);
  }

  @override
  void dispose() {
    super.dispose();
    sidesController.dispose();
    radiusController.dispose();
    rotationController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sidesController.repeat(reverse: true);
    radiusController.repeat(reverse: true);
    rotationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
              [sidesAnimation, radiusAnimation, rotationAnimation]),
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateY(rotationAnimation.value)
                ..rotateZ(rotationAnimation.value)
                ..rotateX(rotationAnimation.value),
              child: CustomPaint(
                painter: Polygon(sides: sidesAnimation.value),
                child: SizedBox(
                  width: radiusAnimation.value,
                  height: radiusAnimation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
