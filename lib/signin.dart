import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:trial/reuseablewidgets.dart';
import 'package:trial/unitTracker.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logoWidget('assets/images/k.png'),
                SizedBox(
                  height: 70,
                ),
                reuseableTexField('Enter Email Id', Icons.person_2_outlined,
                    false, _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reuseableTexField('Enter userName', Icons.person_2_outlined,
                    false, _userNameTextController),
                SizedBox(
                  height: 20,
                ),
                reuseableTexField('Enter Password', Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 27,
                ),
                signinButton(context, false, () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    // Reset text field controllers after successful login
                    _emailTextController.clear();
                    _passwordTextController.clear();
                    _userNameTextController.clear();

                    // Navigate to home screen upon successful sign-in
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UnitTrackerPage()),
                    );
                  } on FirebaseAuthException catch (error) {
                    String errorMessage = error.message ?? "An error occurred";
                    Fluttertoast.showToast(
                        msg: errorMessage,
                        gravity: ToastGravity.TOP,
                        textColor: Colors.red,
                        backgroundColor: Colors.white);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
