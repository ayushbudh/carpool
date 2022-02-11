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
                  Text(
                    'Good Day, Jack!',
                    style: Theme.of(context).textTheme.headline5,
                  ),
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
              Text('Recent Activity',
                  style: Theme.of(context).textTheme.headline6),
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
                      Text(
                        'Rebeka ratry',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(padding: const EdgeInsets.all(3)),
                      Text('22 Jan 2020',
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+\$1,190.00'),
                  Padding(padding: const EdgeInsets.all(3)),
                  Text('03:25am'),
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
                      Text(
                        'Rebeka ratry',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(padding: const EdgeInsets.all(3)),
                      Text('22 Jan 2020',
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+\$1,190.00'),
                  Padding(padding: const EdgeInsets.all(3)),
                  Text('03:25am'),
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
                      Text(
                        'Rebeka ratry',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(padding: const EdgeInsets.all(3)),
                      Text('22 Jan 2020',
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+\$1,190.00'),
                  Padding(padding: const EdgeInsets.all(3)),
                  Text('03:25am'),
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
              onPressed: () {},
              child: Text(
                'Drive',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class AccountCard extends StatelessWidget {
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
                Text(
                  'Ebl titanium account',
                  style: TextStyle(color: Colors.white),
                ),
                Text('Jack Sim', style: TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '\$6,190.00',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Text(
                      'Total Balance',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Added card:05',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Ac. no. 2234521',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
