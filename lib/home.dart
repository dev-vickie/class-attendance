import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trial/reuseablewidgets.dart';
import 'package:trial/unitTracker.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logoWidget('assets/images/k.png'),
                SizedBox(
                  height: 70,
                ),
                reuseableTexField('Enter userName', Icons.person_2_outlined,
                    false, _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reuseableTexField('Enter Password', Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(height: 27),
                signinButton(context, true, () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    // Reset text field controllers after successful login
                    _emailTextController.clear();
                    _passwordTextController.clear();

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
                SizedBox(
                  height: 40,
                ),
                signupOption(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
