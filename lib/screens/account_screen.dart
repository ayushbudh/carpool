import 'package:carpool_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carpool_app/services/map_screen_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final FirebaseService _auth = FirebaseService();
  late TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController(text: _auth.getEmail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    final List<String> entries = <String>[
      'Account',
      'Card Management',
      'Security'
    ];
    final List<int> colorCodes = <int>[600, 500, 100];
    return Column(children: [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: widthSize * 0.08,
                top: heightSize * 0.05,
                bottom: heightSize * 0.03),
            child: Text(
              "Account",
              style: TextStyle(fontSize: heightSize * 0.03),
            ),
          )
        ],
      ),
      Container(
          margin:
              EdgeInsets.only(left: widthSize * 0.06, right: widthSize * 0.05),
          height: heightSize * 0.30,
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                color: Color.fromARGB(255, 226, 224, 224),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('${entries[index]}'),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )),
    ]);
  }
}
