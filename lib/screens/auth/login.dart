
import 'package:flutter/material.dart';
import 'package:flutter_finish/screens/auth/phone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/btn_route.dart';
import '../main_page.dart';

class Login extends StatefulWidget {
  static String id = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? key = await pref.getString("key_token");
    if (key != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 101.0,
              ),
              Image(
                image: AssetImage('images/logo.png'),
                height: 141.0,
                width: 141.0,
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                'seti.inno',
                style: TextStyle(
                    color: Color(0xff205692),
                    fontSize: 62.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Рационaлизатор',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xff2C2929),
                ),
              ),
              SizedBox(
                height: 183.0,
              ),
              Btn_R(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Phone_Number1()));
                  },
                  text: 'Регистрация'),
            ],
          ),
        ),
      ),
    );
  }
}
