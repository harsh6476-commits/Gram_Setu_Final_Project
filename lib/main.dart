import 'package:flutter/material.dart';
// Import the file where you pasted the UI code
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gram Setu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      // Set the home property to the class name from your home.dart file
      home: const GramSetuHomePage(),
    );
  }
}