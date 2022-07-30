import 'package:droneapp/constants/styles.dart';
import 'package:flutter/material.dart';

class InpuTextField extends StatelessWidget {
  const InpuTextField({
    Key? key,
    required this.secure,
    required this.controller,
    required this.hintTexts,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintTexts;
  final bool secure;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: TextField(
        obscureText: secure,
        style: textFieldHintText,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(width: 0, color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(width: 2, color: Color(0xFF21242D)),
          ),
          hintText: hintTexts,
          hintStyle: TextStyle(
            color: const Color(0XFF494D58),
          ),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
