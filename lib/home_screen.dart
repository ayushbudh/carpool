import 'package:flutter/material.dart';

import 'auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
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
        FutureBuilder<Map>(
          future: _auth.getFullName(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: heightSize * 0.02, left: widthSize * 0.03),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(widthSize * 0.02),
                        child: Icon(Icons.account_circle,
                            size: heightSize * 0.065),
                      ),
                      Column(
                        children: [
                          buildText('Good Day, ${snapshot.data!["firstName"]}',
                              TextStyle(fontSize: heightSize * 0.03)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: widthSize * 0.07,
                      right: widthSize * 0.07,
                      top: heightSize * 0.02,
                      bottom: heightSize * 0.02),
                  child: AccountCard(
                      snapshot.data!["firstName"] +
                          " " +
                          snapshot.data!["lastName"],
                      heightSize,
                      widthSize),
                ),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Text(
                      'We are having some problem getting your details. Please try again later.',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                )
              ];
            } else {
              children = const <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 40),
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(
              left: widthSize * 0.07,
              right: widthSize * 0.07,
              top: heightSize * 0.02,
              bottom: heightSize * 0.02),
          child: Row(
            children: [
              buildText(
                  'Recent Activity', TextStyle(fontSize: heightSize * 0.03)),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                left: widthSize * 0.07, right: widthSize * 0.07),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 226, 224, 224),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            height: heightSize * 0.40,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.account_circle,
                              size: heightSize * 0.065),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildText('Rebeka ratry',
                                TextStyle(fontSize: widthSize * 0.04)),
                            Padding(padding: const EdgeInsets.all(3)),
                            buildText('22 Jan 2020',
                                TextStyle(fontSize: widthSize * 0.04)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildText('+\$1,190.00',
                            TextStyle(fontSize: widthSize * 0.04)),
                        Padding(padding: const EdgeInsets.all(3)),
                        buildText(
                            '03:25am', TextStyle(fontSize: widthSize * 0.04)),
                      ],
                    )
                  ],
                ),
              ],
            ))
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
  final String fullName;
  final double heightSize;
  final double widthSize;
  AccountCard(this.fullName, this.heightSize, this.widthSize);

  Widget buildText(text, style) {
    return Container(
      child: FittedBox(
        child: Text(text, style: style),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: heightSize * 0.22,
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
                    TextStyle(color: Colors.white, fontSize: widthSize * 0.03),
                  ),
                  buildText(
                      this.fullName,
                      TextStyle(
                          color: Colors.white, fontSize: widthSize * 0.03)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      buildText(
                        '\$6,190.00',
                        TextStyle(
                            fontSize: widthSize * 0.08, color: Colors.white),
                      ),
                      buildText(
                        'Total Balance',
                        TextStyle(
                            color: Colors.white, fontSize: widthSize * 0.03),
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
                    TextStyle(color: Colors.white, fontSize: widthSize * 0.03),
                  ),
                  buildText(
                    'Ac. no. 2234521',
                    TextStyle(color: Colors.white, fontSize: widthSize * 0.03),
                  ),
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: const Color(0xff199EFF),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onTap: () {
        print("go to account card");
      },
    );
  }
}
