/*
* this animation uses already built widget to animate things on the screen like
* animated container or animated opacity all you need to do is provide a duration
* a curve and everything animates by it self i wrote a blog about this*/
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

const defaultWidth = 100.0;

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var isZoomedIn = false;
  var buttonTitle = 'Zoom In';
  var width = defaultWidth;
  var curve = Curves.bounceOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              color: Colors.blue,
              duration: Duration(milliseconds: 370),
              curve: curve,
              width: width,
              //use an image instead of a icon i don't want to run pub get because
              //i would temper with the pubspec.yaml file
              child: Icon(
                Icons.account_circle_outlined,
                color: Colors.pink,
                size: 100.0,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isZoomedIn = !isZoomedIn;
                  buttonTitle = isZoomedIn ? 'Zoom Out' : 'Zoom In';
                  width = isZoomedIn
                      ? MediaQuery.of(context).size.width
                      : defaultWidth;
                  curve = isZoomedIn ? Curves.bounceInOut : Curves.bounceIn;
                });
              },
              child: Text(buttonTitle),
            ),
          ],
        ),
      ),
    );
  }
}
