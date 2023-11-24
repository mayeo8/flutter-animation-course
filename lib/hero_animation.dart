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

class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({required this.name, required this.age, required this.emoji});
}

const people = [
  Person(name: 'john', age: 20, emoji: '👨🏻‍🦰'),
  Person(name: 'jane', age: 21, emoji: '👩🏻‍🦰'),
  Person(name: 'jack', age: 22, emoji: '👨🏿‍🦳'),
];

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPage(person: person),
                  ),
                );
              },
              leading: Hero(
                  tag: person.name,
                  child: Text(
                    person.emoji,
                    style: const TextStyle(fontSize: 40),
                  )),
              title: Text(person.name),
              subtitle: Text('${person.age} years old'),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              switch (flightDirection) {
                case HeroFlightDirection.push:
                  return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                          scale: animation.drive(
                            Tween<double>(begin: 0.0, end: 1.0)
                                .chain(CurveTween(curve: Curves.fastOutSlowIn)),
                          ),
                          child: toHeroContext.widget));
                case HeroFlightDirection.pop:
                  return Material(
                      color: Colors.transparent, child: fromHeroContext.widget);
              }
            },
            tag: person.name,
            child: Text(
              person.emoji,
              style: const TextStyle(fontSize: 50.0),
            )),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Text(
              person.name,
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              '${person.age} years old',
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
