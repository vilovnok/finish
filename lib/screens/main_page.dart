import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_finish/screens/show_request/expertises/expertises.dart';
import 'package:flutter_finish/screens/show_request/projects/projects.dart';
import 'package:flutter_finish/screens/status_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sections_action.dart';
import 'create_request/create_theme.dart';

class MainPage extends StatefulWidget {
  static String id = '/mainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final storage = SharedPreferences.getInstance();
  String? text_will;
  String token = '';
  List<Post_Api> posts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    getPosts();
    delete_Keys();
  }

  Future getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('key_token')!;
      text_will = pref.getString('key_text_will');
      UserInfo.tokenString = token;
    });
  }

  Future getKeys() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getKeys());
  }

  Future delete_Keys() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(
      'key_text_will',
    );
    pref.remove(
      'key_video_now',
    );
    pref.remove(
      'key_image',
    );
    pref.remove(
      'key_code',
    );
    pref.remove(
      'key_text_now',
    );

    pref.remove(
      'key_theme',
    );
    pref.remove(
      'key_image_now',
    );
    pref.remove(
      'key_title',
    );

    pref.remove(
      'key_text_need',
    );
    pref.remove(
      'key_image_need',
    );
    pref.remove(
      'key_video_need',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 121.0),
                      child: Text(
                        'seti.inno',
                        style:
                            TextStyle(fontSize: 36.0, color: Color(0xff205692)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => StatusScreen())));
                          },
                          child: Image.asset('images/icon.png')),
                    )
                  ],
                ),
              ),
              Sections_action(
                image: 'images/create.png',
                word_1: 'Создать',
                word_2: 'предложение',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Create_theme(
                            token: token,
                          ))));
                  setState(() {
                    getPosts();
                    getKeys();
                  });
                },
              ),
              Sections_action(
                image: 'images/idea.png',
                word_1: 'Заявки',
                word_2: '',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Projects12(
                            token: token,
                            number: 0,
                          ))));
                },
              ),
              Sections_action(
                image: 'images/skills.png',
                word_1: 'Экспертизы',
                word_2: '',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Exper(
                            token: token,
                            number: 0,
                          ))));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final client = HttpClient();

  Future<void> getPosts() async {
    final json = await get('https://msofter.com/rosseti/public/api/topics')
        as Map<String, dynamic>;

    final data = json["topics"] as List<dynamic>;

    posts = data
        .map((dynamic e) => Post_Api.fromJson(e as Map<String, dynamic>))
        .toList();
    print(posts[0].title.runtimeType);
  }

  Future<dynamic> get(String ulr) async {
    Uri url = Uri.parse(ulr);

    final request = await client.getUrl(url);
    request.headers.removeAll(HttpHeaders.acceptEncodingHeader);
    request.headers.add("Accept", "application/json");
    request.headers.add("Authorization", "Bearer $token");
    final response = await request.close();

    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();

    final dynamic json = jsonDecode(jsonString);

    return json;
  }
}

class Post_Api {
  int? id;
  String? title;
  Post_Api({required this.id, required this.title});

  factory Post_Api.fromJson(Map<String, dynamic> json) =>
      _$Post_ApiFromJson(json);
}

Post_Api _$Post_ApiFromJson(Map<String, dynamic> json) {
  return Post_Api(id: json['id'] as int, title: json['title'] as String);
}
