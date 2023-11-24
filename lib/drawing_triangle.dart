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

extension ToPath on CircleSide{
  Path toPath(Size size){
    final path  = Path();
    final point1 = Offset(size.width / 2, 0);
    final point2 = Offset(size.width, size.height);
    final point3 = Offset(0, size.height);

    // Move to the first vertex
    path.moveTo(point1.dx, point1.dy);

    // Connect the vertices to form the triangle
    path.lineTo(point2.dx, point2.dy);
    path.lineTo(point3.dx, point3.dy);

    //the returning path is returned as an output to be used around the project
    //it returns the already drawn path or shape
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: const HalfCircleClipper(side: CircleSide.left),
              child: Container(
                color: Colors.blue,
                width: 200,
                height: 200,
              ),
            ),
            ClipPath(
              clipper: const HalfCircleClipper(side: CircleSide.right),
              child: Container(
                color: Colors.yellow,
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
