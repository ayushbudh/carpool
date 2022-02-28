import 'package:carpool_app/auth.dart';
import 'package:carpool_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'launch_screen_options.dart';
import 'package:carpool_app/auth_screen.dart';
import 'launch_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/launchscreenoptions': (context) => LaunchScreenOptions(),
        '/': (context) => StreamProvider.value(
              initialData: null,
              value: AuthService().user,
              child: LaunchScreen(),
            ),
        '/auth': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
