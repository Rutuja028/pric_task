import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/homePage.dart';
import 'package:task/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    whereToGo();
  }

  void _logIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      UserCredential? user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("email", email);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      log(e.toString());
    }

    //  AdditionalUserInfo? value = user.additionalUserInfo;
    // log(user.toString());

    // // if (user != null) {
    // //   print("Succesfully LogIn");

    // } else {
    //   _errorMessage = "Invalid email or password";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Technical Round Task",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        offset: Offset(0, 3),
                        blurRadius: (10),
                      ),
                    ]),
                height: 35,
                width: 250,
                child: TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Email id",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      fontSize: 15,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(250, 235, 235, 0.135),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a User Name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        offset: Offset(0, 3),
                        blurRadius: (10),
                      ),
                    ]),
                height: 35,
                width: 250,
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: !_isPasswordVisible,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      fontSize: 15,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(250, 235, 235, 0.135),
                        width: 2,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter password";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromRGBO(14, 161, 125, 1),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  onPressed: _logIn,
                  child: const Text("Log In",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text("Sign Up",
                          style: TextStyle(
                            color: Color.fromRGBO(14, 161, 125, 1),
                          )))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();

    sharedPref.getBool("Login");
  }
}
