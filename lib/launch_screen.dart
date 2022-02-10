import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    double? _currentPageValue = 0.0;
    final PageController controller = PageController();

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Color(0xffFF1522),
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                  Center(
                    child: Text(
                      'Help Each Other',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    heightFactor: 13,
                  ),
                  Center(
                    child: Text(
                      'Meet new people along the commute',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    heightFactor: 30,
                  ),
                  Center(child: Image.asset('carouselscreen1.png', width: 500))
                ]),
                color: Color(0xff199EFF),
              ),
              Container(
                child: Stack(children: [
                  Center(
                    child: Text(
                      'Save Environment',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    heightFactor: 10,
                  ),
                  Center(
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
                    child: Image.asset('carouselscreen2.png', width: 220),
                  )
                ]),
                color: Color(0xffF7F7F7),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: new EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                    child: SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  onDotClicked: (index) => controller.animateToPage(index,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.bounceOut),
                )),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () {},
                    child: Text('Let\'s Go'),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
