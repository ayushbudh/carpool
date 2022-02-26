import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = true;
  String _failureReason = '';

  void _loginSignupNavigator(BuildContext context, String url) {
    Navigator.of(context).pushReplacementNamed(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff199EFF),
        body: Container(
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.only(top: 60),
          child: Form(
            key: _formKey, // NEW
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sign In',
                    style: TextStyle(
                        fontSize: 30,
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
                              border: Border.all(color: Colors.red)),
                          child: Text(
                            _success ? '' : _failureReason,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
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
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
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
                    if (_formKey.currentState!.validate()) {}
                  },
                  // UPDATED
                  child: const Text('Sign In'),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 38.0),
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
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {}
                  },
                  // UPDATED
                  child: const Text('Google Signin'),
                ),
                Padding(
                  padding: const EdgeInsets.all(50),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Don\'t have an account ? Swipe left',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
