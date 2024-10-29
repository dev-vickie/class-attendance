import 'package:flutter/material.dart';
import 'package:trial/signin.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.cover,
    width: 240,
    height: 240,
  );
}

TextField reuseableTexField(String text, IconData icon, bool isPasswordofType,
    TextEditingController controller) {
  return TextField(
      controller: controller,
      obscureText: isPasswordofType,
      enableSuggestions: !isPasswordofType,
      cursorColor: Colors.black12,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          labelText: text,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 0, style: BorderStyle.none))),
      keyboardType: isPasswordofType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress);
}

Container signinButton(context, bool islogin, Function ontap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        ontap();
      },
      child: Text(
        islogin ? " LOG IN" : "SIGN UP",
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black12;
            }

            return Colors.grey[150];
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Row signupOption(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Don't have an account ? ",
        style: TextStyle(color: Colors.black12),
      ),
      GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => signUp()));
          },
          child: Text(
            "Sign up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
    ],
  );
}
