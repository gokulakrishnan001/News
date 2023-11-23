import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news/view/HomeScreen.dart';
import 'package:news/view/SignupActivity.dart';

import '../Firebase/Auth.dart';
import '../Firebase/Vailator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 105, 54, 244),
        title: const Text('News'),
        centerTitle: false,
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black12, Colors.white, Colors.black12])),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, right: 24.0, top: 48),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 30.0, top: 12),
                          child: Text('Login',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30)),
                        ),
                        const SizedBox(
                          height: 90.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailTextController,
                                validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter a Email",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 105, 54, 244),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              TextFormField(
                                controller: _passwordTextController,
                                obscureText: true,
                                validator: (value) =>
                                    Validator.validatePassword(
                                  password: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter a Password",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 105, 54, 244),
                                    ),
                                  ),
                                ),
                                keyboardAppearance: Brightness.light,
                              ),
                              SizedBox(height: 30.0),
                              _isProcessing
                                  ? CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                User? user =
                                                    await FirebaseAuthHelper
                                                        .signInUsingEmailPassword(
                                                  email:
                                                      _emailTextController.text,
                                                  password:
                                                      _passwordTextController
                                                          .text,
                                                );

                                                if (user != null) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen(),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color.fromARGB(
                                                          255, 105, 54, 244)),
                                            ),
                                            child: const Text(
                                              'Sign In',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 24.0),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpScreen(),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color.fromARGB(
                                                          255, 245, 244, 248)),
                                            ),
                                            child: const Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
