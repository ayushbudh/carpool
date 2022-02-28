import 'dart:js';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xff199EFF),
      minimumSize: const Size(160, 50),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle, size: 50),
              ),
              Column(
                children: [
                  buildText(
                      'Good Day, Jack!', Theme.of(context).textTheme.headline5),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          child: AccountCard(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          child: Row(
            children: [
              buildText(
                  'Recent Activity', Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.account_circle, size: 50),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildText('Rebeka ratry',
                          Theme.of(context).textTheme.headline6),
                      Padding(padding: const EdgeInsets.all(3)),
                      buildText(
                          '22 Jan 2020', Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildText('+\$1,190.00', TextStyle()),
                  Padding(padding: const EdgeInsets.all(3)),
                  buildText('03:25am', TextStyle()),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.account_circle, size: 50),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildText('Rebeka ratry',
                          Theme.of(context).textTheme.headline6),
                      Padding(padding: const EdgeInsets.all(3)),
                      buildText(
                          '22 Jan 2020', Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildText('+\$1,190.00', TextStyle()),
                  Padding(padding: const EdgeInsets.all(3)),
                  buildText('03:25am', TextStyle()),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.account_circle, size: 50),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildText('Rebeka ratry',
                          Theme.of(context).textTheme.headline6),
                      Padding(padding: const EdgeInsets.all(3)),
                      buildText(
                          '22 Jan 2020', Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildText('+\$1,190.00', TextStyle()),
                  Padding(padding: const EdgeInsets.all(3)),
                  buildText('03:25am', TextStyle()),
                ],
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/drive');
              },
              child: Row(
                children: [
                  buildText('Drive', TextStyle(fontSize: 22)),
                  Padding(padding: const EdgeInsets.all(2)),
                  Icon(Icons.double_arrow)
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildText(text, style) {
    return Container(
      child: FittedBox(
        child: Text(text, style: style),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  Widget buildText(text, style) {
    return Container(
      child: FittedBox(
        child: Text(text, style: style),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(
                  'Ebl titanium account',
                  TextStyle(color: Colors.white),
                ),
                buildText('Jack Sim', TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    buildText(
                      '\$6,190.00',
                      TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    buildText(
                      'Total Balance',
                      TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(
                  'Added card:05',
                  TextStyle(color: Colors.white),
                ),
                buildText(
                  'Ac. no. 2234521',
                  TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: const Color(0xff199EFF),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
