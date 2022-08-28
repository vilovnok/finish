import 'package:flutter/material.dart';

class Btn_R extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;

  const Btn_R({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: MaterialButton(

        onPressed: onPressed,
        minWidth: 305.0,
        height: 58.0,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20.0,
              color: Color(0xff205692),
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
