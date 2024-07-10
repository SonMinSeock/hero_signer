import 'package:flutter/material.dart';
import 'home.dart'; // Import the home.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(), // Set MyHomePage from home.dart as the home widget
    );
  }
}
