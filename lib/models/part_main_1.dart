import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../screens/status_screen.dart';




class Part_for_video1 extends StatelessWidget {
  final String text;

  const Part_for_video1({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('images/Vector.png'),
          ),
        ),
        Text(
          text,
          style: TextStyle(
              fontFamily: 'ABeeZee',
              color: Color(0xff205692),
              fontSize: 36.0,
              fontWeight: FontWeight.w400),
        ),
        FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => StatusScreen())));
            },
            child: Image.asset('images/icon.png'))
      ],
    );
  }
}
