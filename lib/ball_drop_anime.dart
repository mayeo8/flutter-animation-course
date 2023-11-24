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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  late AnimationController _rollAnimationController;
  late Animation _rollAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _rollAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    _rollAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation =
        Tween<double>(begin: 0, end: MediaQuery.of(context).size.height / 1.5)
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _rollAnimation =
        Tween<double>(begin: 0, end: MediaQuery.of(context).size.width).animate(
      CurvedAnimation(parent: _rollAnimationController, curve: Curves.easeIn),
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller
            ..reset()
            ..forward();
          //use this if you want one animation to stop before another starts
          // // _controller.addStatusListener((status) {
          // //   if (status == AnimationStatus.completed) {
          _rollAnimationController
            ..reset()
            ..forward();
          // //   }
          // // });
        },
        backgroundColor: Colors.pink,
        child: const Text('Press'),
      ),
      appBar: AppBar(
        title: const Text('Animation'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_animation, _rollAnimation]),
            builder: (BuildContext context, Widget? child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, _animation.value, 0.0)
                  ..translate(_rollAnimation.value, 0.0, 0.0),
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
