import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/btn_enter.dart';
import '../../models/btn_route.dart';
import '../main_page.dart';

class Phone_Number1 extends StatefulWidget {
  static String id = '/phone1';

  const Phone_Number1({Key? key}) : super(key: key);

  @override
  State<Phone_Number1> createState() => _Phone_Number1State();
}

class _Phone_Number1State extends State<Phone_Number1> {
  TextEditingController _phonecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 273.0),
              child: Btn_E(
                prefix: Text(''),
                controller: _phonecontroller,
                maxLength: 20,
                text: 'Телефон',
                onChanged: (value) {},
                type: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Btn_R(
                  onPressed: () {
                    login();
                  },
                  text: 'Далее'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    if (_phonecontroller.text.isNotEmpty &&
        _phonecontroller.text.length >= 11) {
      var response = await http.post(
          Uri.parse('https://msofter.com/rosseti/public/api/auth/phone'),
          body: ({
            'phone': _phonecontroller.text,
          }));
      var resp = await http.post(
          Uri.parse("https://msofter.com/rosseti/public/api/auth/verify-code"),
          body: ({"phone": _phonecontroller.text}));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('Code : ${body["code"]}');

        pageRoute(body["code"]);
      } else {
        print('Invalid Credentials');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Black Field Not Allowed')));
    }
  }

  void pageRoute(String code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('key_code', code);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Phone_Number2()),
        (route) => false);
  }
}

class Phone_Number2 extends StatefulWidget {
  static String id = '/phone2';
  const Phone_Number2({Key? key}) : super(key: key);

  @override
  State<Phone_Number2> createState() => _Phone_Number2State();
}

class _Phone_Number2State extends State<Phone_Number2> {
  String code = '';
  TextEditingController _codecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      code = pref.getString('key_code')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 273.0),
              child: Btn_E(
                controller: _codecontroller,
                maxLength: 11,
                prefix: Text('${code}'),
                text: 'Код из СМС ',
                onChanged: (value) {},
                type: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Btn_R(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => MainPage()));
                    login2();
                  },
                  text: 'Далее'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login2() async {
    if (_codecontroller.text.isNotEmpty && _codecontroller.text.length >= 4) {
      var response = await http.post(
          Uri.parse('https://msofter.com/rosseti/public/api/auth/verify-code'),
          body: ({
            'code': _codecontroller.text,
          }));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('Token : ${body["token"]}');

        pageRoute(body["token"]);
      } else {
        print('Invalid Credentials');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Black Field Not Allowed')));
    }
  }

  void pageRoute(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('key_token', token);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
  }
}
