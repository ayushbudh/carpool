import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class SignInScreen extends StatefulWidget {
  final String role;
  const SignInScreen(this.role);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = true;
  String _failureReason = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Color(0xff199EFF),
        body: Container(
          padding: EdgeInsets.all(heightSize * 0.05),
          margin: EdgeInsets.only(top: heightSize * 0.02),
          child: Form(
            key: _formKey, // NEW
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sign In',
                    style: TextStyle(
                        fontSize: heightSize * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Container(
                  width: widthSize * 0.60,
                  alignment: Alignment.center,
                  child: _success
                      ? Text("")
                      : Container(
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          child: Text(
                            _success ? '' : _failureReason,
                            style: TextStyle(
                                color: Colors.red, fontSize: heightSize * 0.02),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                          horizontal: widthSize * 0.04,
                          vertical: heightSize * 0.02),
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white;
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Color(0xffFF1522);
                    }),
                  ),
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      String response = await _auth.sigInWithEmail(
                          context,
                          _emailController.value.text,
                          _passwordController.value.text,
                          widget.role);
                      print(response);
                      if (response != "None") {
                        setState(() {
                          _success = false;
                          _failureReason = response;
                        });
                      }
                    }
                  },
                  // UPDATED
                  child: const Text('Sign In'),
                ),
                Padding(
                  padding: EdgeInsets.all(heightSize * 0.005),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                          horizontal: widthSize * 0.04,
                          vertical: heightSize * 0.02),
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white;
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Color(0xffFBBC05);
                    }),
                  ),
                  onPressed: () async {
                    String response =
                        await _auth.signInSignUpWithGoogle(widget.role);
                    print("response" + response);

                    if (response == "None") {
                      Navigator.of(context).pushReplacementNamed("/home");
                    } else {
                      setState(() {
                        _success = false;
                        _failureReason =
                            "Google signin failed. Please try again later!";
                      });
                    }
                  },
                  child: const Text('Google Signin'),
                ),
                Padding(
                  padding: EdgeInsets.all(heightSize * 0.03),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: Text(
                    'Don\'t have an account ?',
                    style: TextStyle(
                        color: Colors.white, fontSize: heightSize * 0.025),
                  ),
                ),
                Container(
                    height: heightSize * 0.03,
                    width: heightSize * 0.20,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: Center(
                      child: Text(
                        "Swipe left",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: heightSize * 0.02,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
