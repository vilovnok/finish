import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/btn_route.dart';
import 'main_page.dart';

class StatusScreen extends StatefulWidget {
 const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    user();
    super.initState();
  }

  Color color_blue = Color(0xff205692);

  var _data = {};

  void user() async {
    try {
      final token = 'Bearer ${UserInfo.tokenString}';
      final response = await http.get(
          Uri.parse('http://msofter.com/rosseti/public/api/user'),
          headers: {
            'Accept': 'application/json',
            'Authorization': token,
            'Content-Type': 'multipart/form-data'
          });
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _data = jsonData;
        });
      } else {
        debugPrint('я не могу: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  title(),
                ],
              ),
              Image.asset('images/crowns.png'),
              SizedBox(
                height: 17,
              ),
              Text(
                'Серебрянный статус',
                style: TextStyle(
                    color: color_blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Оценок',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${_data['ratings_count']}',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Коментариев',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${_data['comments_count']}',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Предложений',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${_data['proposals_count']}',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Одобрено',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${_data['accepted_proposals_count']}',
                      style: TextStyle(
                          color: color_blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Итого 1300 бонусов',
                style: TextStyle(
                    color: color_blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 22,
              ),
              Text(
                'До золотого статуса\nеще 15 оценок или\n6 коментариев или 1\nпредложение',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color_blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 32,
              ),
              Btn_R(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  text: 'Готово'),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: Text(
            'Мой статус',
            style: TextStyle(
                fontFamily: 'ABeeZee',
                color: Color(0xff205692),
                fontSize: 36.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 22.0 - 17.0),
          child: Image.asset('images/icon.png'),
        )
      ],
    );
  }
}

class UserInfo {
  static dynamic tokenString = '';
  static dynamic idString = '';
  static dynamic nameString = '';
  static dynamic text_nowString = '';
  static dynamic text_needString = '';
  static dynamic text_poziString = '';

  static dynamic image_nowString = '';
  static dynamic image_needString = '';
  static dynamic video_needString = '';
  static dynamic video_nowString = '';
  static dynamic titleString='';
  static dynamic themeString='';
}


// imagePath_now: UserInfo.image_nowString,
        // videoPath_now: UserInfo.video_nowString,
        // title: UserInfo.titleString,
        // theme: UserInfo.themeString,
        // imagePath_need: UserInfo.image_needString,
        // videoPath_need: UserInfo.video_needString,
        // text_positive: UserInfo.text_poziString,
        // text_now: UserInfo.text_nowString,
        // text_need: UserInfo.text_needString
        
        //
        //
    // print("title ${UserInfo.titleString}");
    // print("theme ${UserInfo.themeString}");
    // print("text_now ${UserInfo.text_nowString}");
    // print("image_now ${UserInfo.image_nowString}");
    // print("video_now ${UserInfo.video_nowString}");

    // print("text_need ${UserInfo.text_needString}");
    // print("image_need ${UserInfo.image_needString}");
    // print("video_need ${UserInfo.video_needString}");
    // print('text_positive ${UserInfo.text_poziString}');