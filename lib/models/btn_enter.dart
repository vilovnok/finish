import 'package:flutter/material.dart';

class Btn_E extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextInputType type;
  final String text;
  final maxLength;
  final controller;
  final prefix;

  Btn_E(
      {required this.controller,required this.maxLength,
      required this.onChanged,
      required this.text,
      required this.type,required this.prefix});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 305.0,
      height: 78.0,
      child: Material(
        child: TextField(
//запомнить
          maxLength: maxLength,
          controller: controller,

          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
          keyboardType: type,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: text,
            prefix: prefix,

            contentPadding: EdgeInsets.all(18.0),
            border: OutlineInputBorder(),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xff205692)),
              borderRadius: BorderRadius.circular(24.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xff205692)),
              borderRadius: BorderRadius.circular(24.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff205692),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      ),
    );
  }
}