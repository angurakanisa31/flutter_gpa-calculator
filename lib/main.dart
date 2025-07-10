import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(GpaCalculatorApp());
}

class GpaCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: SplashPage(), // Launch from splash screen
    );
  }
}