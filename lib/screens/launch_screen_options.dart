import 'package:carpool_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class LaunchScreenOptions extends StatelessWidget {
  const LaunchScreenOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    final ButtonStyle optionButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xffFF1522),
      minimumSize: Size(widthSize * 0.20, heightSize * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: widthSize * 0.07, vertical: heightSize * 0.02),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xff199EFF),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: heightSize * 0.10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select an option',
                  style: TextStyle(
                      fontSize: widthSize * 0.10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.all(heightSize * 0.05),
                child: ElevatedButton(
                  style: optionButtonStyle,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AuthScreen("driver")));
                  },
                  child: const Text('Driver'),
                )),
            Container(
              child: ElevatedButton(
                style: optionButtonStyle,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AuthScreen("rider")));
                },
                child: const Text('Rider'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
