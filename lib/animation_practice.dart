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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  //declare both the AnimationController and the the Animation
  @override
  //initializes both in the initState function
  void initState() {
    super.initState();
    //assigning the controller to a AnimationController object which takes in a
    //vsync, duration

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    //assigning the animation to a Tween which just goes from one point to another
    //its not an animation so you have to animate it with a controller
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    //i this this is where you start the animation you can use either forward,
    //backward, repeat or reverse it starts the animation
    _controller.repeat();
  }

  //disposes the animation
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
//wrap it around anything you want to animate so it knows to rebuild the page
//based on the value change
        child: AnimatedBuilder(
//give it the value that changes so it can track it
          animation: _controller,
          builder: (context, child) {
//it transform any child widget on screen
// and if the animated object goes off screen it won't cause a render overflow
            return Transform(
//the pivot center where all the animation revolves around
              alignment: Alignment.center,
//telling it to clear any prior pivot center and rotate it in a particular axis
              transform: Matrix4.identity()..rotateY(_animation.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),),
                child: Text(_animation.value.toStringAsFixed(2)),
              ),
            );
          },
        ),
      ),
    );
  }
}
