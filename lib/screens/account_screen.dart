import 'package:carpool_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carpool_app/services/map_screen_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final AuthService _auth = AuthService();
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
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xffFF1522),
      minimumSize: Size(widthSize * 0.20, heightSize * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: widthSize * 0.07, vertical: heightSize * 0.01),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    return Container(
      child: Center(
          child: Text('${context.watch<MapScreenProvider>().getMapHeight}')),
    );
  }
}
