import 'package:carpool_app/auth_screen.dart';
import 'package:flutter/material.dart';
import 'launch_screen_options.dart';
import 'launch_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/launchscreenoptions': (context) => LaunchScreenOptions(),
        '/': (context) => LaunchScreen(),
        '/auth': (context) => AuthScreen()
      },
    );
  }
}
