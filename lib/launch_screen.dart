import 'package:carpool_app/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carpool_app/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final user = Provider.of<User?>(context);

    if (user == null) {
      final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        onPrimary: Colors.black87,
        primary: const Color(0xffFF1522),
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      );

      return Scaffold(
        body: Stack(
          children: [
            PageView(
              /// [PageView.scrollDirection] defaults to [Axis.horizontal].
              /// Use [Axis.vertical] to scroll vertically.
              controller: controller,
              children: <Widget>[
                Container(
                  child: Stack(children: [
                    const Center(
                      child: Text(
                        'Help Each Other',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      heightFactor: 13,
                    ),
                    const Center(
                      child: Text(
                        'Meet new people along the commute',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      heightFactor: 30,
                    ),
                    Center(
                        child: Image.asset('assets/carouselscreen1.png',
                            width: 500))
                  ]),
                  color: const Color(0xff199EFF),
                ),
                Container(
                  child: Stack(children: [
                    const Center(
                      child: Text(
                        'Save Environment',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      heightFactor: 10,
                    ),
                    const Center(
                      child: Text(
                        'Contribute towards sustainable future',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      heightFactor: 24,
                    ),
                    Center(
                      child:
                          Image.asset('assets/carouselscreen2.png', width: 220),
                    )
                  ]),
                  color: const Color(0xffF7F7F7),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                      child: SmoothPageIndicator(
                    controller: controller,
                    count: 2,
                    onDotClicked: (index) => controller.animateToPage(index,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut),
                  )),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, '/launchscreenoptions');
                      },
                      child: const Text('Let\'s Go'),
                    ))
              ],
            )
          ],
        ),
      );
    } else {
      return BaseScreen();
    }
  }
}
