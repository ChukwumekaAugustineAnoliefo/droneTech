import 'package:droneapp/constants/styles.dart';
import 'package:flutter/material.dart';

class ReUsableBtn extends StatelessWidget {
  ReUsableBtn({Key? key, required this.btnText, required this.onPress})
      : super(key: key);
  final String btnText;
  Function onPress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 325,
      child: ElevatedButton(
        onPressed: () {
          onPress();
        },
        child: Text(style: textFieldHintText, btnText),
      ),
    );
  }
}
