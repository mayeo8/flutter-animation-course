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

enum CircleSide { left, right }

//extension enables you to extend the functionality of different data types without
//modifying their source code the CircleSide can be any datatype String, int etc
extension ToPath on CircleSide {
  //creating the toPath function it is an actual function with a return type of Path
  Path toPath(Size size) {
    //the size is used to create and return the created path with specified size
    //while the Path object is used to create graphics and drawings on screen
    final path = Path();
    late Offset offset;
    late bool clockWise;
//the switch is used to draw different shapes depending on the side
//the offset and clockwise variables are used in the drawing we need their values to change depending on the side
    switch (this) {
      case CircleSide.left:
        //the moveTo determine the starting point of the pen since its anticlockwise
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        //in this case we do not have to move since it is clockwise and we start from 0
        //the offset determines where you want to start from and where you want to end
        offset = Offset(0, size.height);
        clockWise = true;
        break;
    }
    //this is actually what is drawing the shape the switch is just making this more clear
    //the radius specify the radius point of the circle
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockWise);
    path.close();
    //the returning path is returned as an output to be used around the project
    //it returns the already drawn path or shape
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  //constructor
  const HalfCircleClipper({required this.side});

  @override
  //toPath is same code in extension
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class _MyHomePageState extends State<MyHomePage> {
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
