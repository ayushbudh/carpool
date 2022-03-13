import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:carpool_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen(this.role);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  bool _success = true;
  String _failureReason = '';

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
                Text('Sign up',
                    style: TextStyle(
                        fontSize: heightSize * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Container(
                  alignment: Alignment.center,
                  child: _success
                      ? Text("")
                      : Container(
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.red,
                          )),
                          child: Text(
                            _success ? '' : _failureReason,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _firstName,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'First Name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _lastName,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Last Name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
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
                      String response = await _auth.signUp(
                          context,
                          _firstName.value.text,
                          _lastName.value.text,
                          _emailController.value.text,
                          _passwordController.value.text,
                          widget.role);

                      if (response != "None") {
                        setState(() {
                          _success = false;
                          _failureReason = response;
                        });
                      }
                    }
                  },
                  // UPDATED
                  child: const Text('Sign up'),
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
                    UserCredential? user;
                    try {
                      UserCredential? user = await _auth.signInWithGoogle();
                      if (user != null) {
                        _auth.storeGoogleUserInCollection(user);
                        Navigator.of(context).pushReplacementNamed("/home");
                      }
                    } catch (e) {
                      setState(() {
                        _success = false;
                        _failureReason =
                            "Google signup failed. Please try again later!";
                      });
                    }
                  },
                  // UPDATED
                  child: const Text('Google Signup'),
                ),
                Padding(
                  padding: EdgeInsets.all(heightSize * 0.03),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: Text(
                    'Already have an account ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: heightSize * 0.025,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: Container(
                      height: heightSize * 0.03,
                      width: heightSize * 0.20,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: Center(
                        child: Text(
                          "Swipe right",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: heightSize * 0.02,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
