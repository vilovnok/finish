import 'package:flutter/material.dart';

import 'btn_enter.dart';
class  Enter_add extends Btn_E {
  final Icon icon;
  Enter_add({
   required int maxLength, required final controller,
    required this.icon,
    required String text,
    required ValueChanged<String> onChanged,
    required TextInputType type,required prefix
  }) : super(text: text, onChanged: onChanged, type: type,maxLength: maxLength,controller: controller,prefix: prefix);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 305.0,
      height: 58.0,
      child: Material(
        child: TextField(
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
          keyboardType: type,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: text,
            suffixIcon: icon,
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
