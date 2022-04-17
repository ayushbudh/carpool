import 'package:carpool_app/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    final PageController controller = PageController();
    final user = Provider.of<User?>(context);

    if (user == null) {
      final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        onPrimary: Colors.black87,
        primary: const Color(0xffFF1522),
        minimumSize: Size(widthSize * 0.10, heightSize * 0.035),
        padding: EdgeInsets.symmetric(
            horizontal: widthSize * 0.10, vertical: heightSize * 0.035),
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
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Help Each Other',
                            style: TextStyle(
                                fontSize: widthSize * 0.10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Meet new people along the commute',
                            style: TextStyle(
                                fontSize: widthSize * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/carouselscreen1.png',
                            height: heightSize * 0.40,
                            width: widthSize * 0.80,
                          )
                        ],
                      ),
                    ],
                  ),
                  color: const Color(0xff199EFF),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save Environment',
                            style: TextStyle(
                                fontSize: widthSize * 0.10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Contribute towards sustainable future',
                            style: TextStyle(
                                fontSize: widthSize * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: heightSize * 0.08)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/carouselscreen2.png',
                            height: heightSize * 0.35,
                            width: widthSize * 0.60,
                          )
                        ],
                      ),
                    ],
                  ),
                  color: const Color(0xffF7F7F7),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: heightSize * 0.04),
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
                    padding: EdgeInsets.all(heightSize * 0.02),
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/launchscreenoptions');
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
