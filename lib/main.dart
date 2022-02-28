import 'package:flutter/material.dart';
import 'package:carpool_app/base_screen.dart';
import 'package:carpool_app/drive_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => BaseScreen(),
        '/drive': (context) => DriveScreen(),
        // '/base': (context) => HomeScreen(),
      },
    );
  }
}
