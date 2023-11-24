import 'package:flutter/material.dart';
import 'dart:math' show pi;

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

const widthAndHeight = 100.0;

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late AnimationController zController;
  late Tween<double> animation;

  @override
  void initState() {
    super.initState();
    xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));
    animation = Tween(begin: 0, end: pi * 2);
  }
  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    xController..reset()..repeat();
    yController..reset()..repeat();
    zController..reset()..repeat();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: widthAndHeight,
              width: double.infinity,
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                xController,
                yController,
                zController
              ]),
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  alignment: Alignment.center,
                  /**basically you can have multiple transforms for one widget
                   * but in this example not just are we creating 3 transform for one widget
                   * like telling it to rotate in x and both y and z axis but we are also
                   * binding one animation(tween) to multiple controller because they have the same begin and end*/
                  transform: Matrix4.identity()
                    ..rotateX(animation.evaluate(xController))
                    ..rotateY(animation.evaluate(yController))
                    ..rotateZ(animation.evaluate(zController)),
                  child: Stack(
                    children: [
                      //back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..translate(0.0,0.0,widthAndHeight),
                        child: Container(
                          color: Colors.purple,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),//front
                      Container(
                        color: Colors.green,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                      //leftSide
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(-(pi / 2)),
                        child: Container(
                          color: Colors.red,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      //rightSide
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY((pi / 2)),
                        child: Container(
                          color: Colors.blue,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      //top
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX((pi / 2)),
                        child: Container(
                          color: Colors.orange,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(-(pi / 2)),
                        child: Container(
                          color: Colors.brown,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
