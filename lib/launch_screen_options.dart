import 'package:flutter/material.dart';

class LaunchScreenOptions extends StatelessWidget {
  const LaunchScreenOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle optionButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xffFF1522),
      minimumSize: const Size(150, 20),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xff199EFF),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150, bottom: 10),
              child: const Text(
                'Select an option',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: optionButtonStyle,
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                  child: const Text('Driver'),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: optionButtonStyle,
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
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
