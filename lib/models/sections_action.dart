import 'package:flutter/material.dart';

class Sections_action extends StatelessWidget {
  final String image;
  final String word_1;
  final String word_2;
  final VoidCallback onPressed;

  Sections_action(
      {required this.image,
      required this.word_1,
      required this.word_2,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 21.0,
      ),
      child: Container(
        height: 165.0,
        width: 305.0,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Expanded(
              //   child: Image.asset(image),
              // ),
              Expanded(
                child: TextButton(
                  onPressed: onPressed,
                  child: Row(

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(image),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Sections_text(
                              text: word_1,
                            ),
                            Sections_text(text: word_2)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Sections_text extends StatelessWidget {
  final String text;
  const Sections_text({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Color(0xff205692),
          fontFamily: 'ABeeZee',
          fontWeight: FontWeight.w400,
          fontSize: 20.0),
    );
  }
}


