import 'package:carpool_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:carpool_app/drive_screen.dart';
import 'package:provider/provider.dart';
import 'base_screen.dart';
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
        '/drive': (context) => DriveScreen(),
        '/launchscreenoptions': (context) => LaunchScreenOptions(),
        '/': (context) => StreamProvider.value(
              initialData: null,
              value: AuthService().user,
              child: LaunchScreen(),
            ),
        '/auth': (context) => AuthScreen("None"),
        '/home': (context) => BaseScreen(),
      },
    );
  }
}
