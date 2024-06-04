import 'package:flutter/material.dart';
import 'HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const myhome(),
      routes: {
        '/splash2': (context) => myhome(),
      },
    );
  }
}
