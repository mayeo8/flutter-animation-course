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
enum CircleSide {left, right}

extension on VoidCallback{
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

extension ToPath on CircleSide{
  Path toPath(Size size){
    final path  = Path();
    late Offset offset;
    late bool clockWise;
    switch(this){
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
        break;
    }
    path.arcToPoint(offset, radius: Radius.elliptical(size.width / 2, size.height / 2), clockwise: clockWise);
    path.close();
    return path;
  }
}
class HalfCircleClipper extends CustomClipper<Path>{
  final CircleSide side;
  //constructor
  const HalfCircleClipper({required this.side});
  @override
  //toPath is same code in extension
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseAnimationController;
  late Animation<double> _counterClockwiseAnimation;

  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _counterClockwiseAnimation = Tween<double>(begin: 0.0, end: -(pi / 2)).animate(
      CurvedAnimation(parent: _counterClockwiseAnimationController, curve: Curves.bounceOut),
    );

    _flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(parent: _flipAnimationController, curve: Curves.bounceOut),
    );
    _counterClockwiseAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _flipAnimation = Tween<double>(begin: _flipAnimation.value, end: _flipAnimation.value + pi).animate(
          CurvedAnimation(parent: _flipAnimationController, curve: Curves.bounceOut),
        );
        _flipAnimationController..reset()..forward();
      }
    });
    _flipAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _counterClockwiseAnimation = Tween<double>(
            begin: _counterClockwiseAnimation.value,
            end:_counterClockwiseAnimation.value + -(pi / 2))
            .animate(
          CurvedAnimation(
            parent: _counterClockwiseAnimationController,
            curve: Curves.bounceOut,
          ),
        );
        _counterClockwiseAnimationController..reset()..forward();
      }
    });
  }


  @override
  void dispose() {
    _counterClockwiseAnimationController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _counterClockwiseAnimationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1),);

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            //you can merge animation builders into 1 instead of creating many
            //animation builders you can merge them as long as it wraps everything
            //that needs to be animated
            //like in this example there are three things being animated but we only
            //needed just one animation builder that wraps all the animations
            _counterClockwiseAnimation,
            _flipAnimationController,
            _flipAnimation
          ]),
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_counterClockwiseAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(_flipAnimation.value),
                    child: ClipPath(
                      clipper: const HalfCircleClipper(side: CircleSide.left),
                      child: Container(
                        color: Colors.blue,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(_flipAnimation.value),
                    child: ClipPath(
                      clipper: const HalfCircleClipper(side: CircleSide.right),
                      child: Container(
                        color: Colors.yellow,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
