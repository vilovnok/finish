import 'package:flutter/material.dart';

class Part_for_video2 extends StatelessWidget {
  final String text;
  TextEditingController controller=TextEditingController();
  InputDecoration decoration =InputDecoration();


  Part_for_video2({Key? key, required this.text,required this.controller,required this.decoration}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 17.0),
              child: Text(
                'Расскажите как $text',
                style: TextStyle(
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    color: Color(0xff205692),
                    fontSize: 20.0),
              ),
            )
          ],
        ),
        Container(
          width: 305,
          height: 292,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: Color(0xff205692), width: 2),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: TextFormField(
              controller: controller,

              obscureText: false,
              decoration: decoration,
              style: TextStyle(
                fontFamily: 'ABeeZee',
                color: Color(0xff12408c),
              ),
              maxLines: 100,
            ),
          ),
        ),
      ],
    );
  }
}
