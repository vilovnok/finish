import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/btn_route.dart';

import 'package:http/http.dart' as http;

import '../../models/part_main_1.dart';
import '../main_page.dart';
import 'create_now.dart';

class Create_theme extends StatefulWidget {
  static String id1 = '/create_description';
  String token;

  Create_theme({Key? key, required this.token}) : super(key: key);

  @override
  State<Create_theme> createState() => _Create_themeState(token);
}

class _Create_themeState extends State<Create_theme> {
  String token;

  _Create_themeState(this.token);

  TextEditingController _titleController = TextEditingController();

  List<Post_Api> list = [];
  List<String> list_title = [];
  List<String> list_theme = [];

  String? title;
  int? topic;
  String? theme;

  Future<List<Post_Api>> getData() async {
    String url = "https://msofter.com/rosseti/public/api/topics";
    var apiresponse = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    var jsonObject = json.decode(apiresponse.body);
    List<dynamic> data = (jsonObject as Map<String, dynamic>)['topics'];

    List<Post_Api> listData = [];

    for (int i = 0; i < data.length; i++)
      listData.add(Post_Api.fromJson(data[i]));

    return listData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListTitle();
    print(token);
    list_theme == 0;
  
  }

  void getListTitle() {
    getData().then((value) {
      list = value;
      for (int i = 0; i < list.length; i++) {
        list_title.add(list[i].title.toString());
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 68.0),
                child: Part_for_video1(
                  text: 'Создать',
                )),
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Text(
                'Расскажите о предложении',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff205692),
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 34.0),
              child: Text(
                'Выберите тему и название',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff205692),
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34.0),
              child: themes("Тема проекта"),
            ),
            titles(_titleController, 'Название'),
            Padding(
              padding: const EdgeInsets.only(top: 183.0),
              child: Btn_R(
                  onPressed: () {
                    find_id(topic.toString());
                    Safekeys(_titleController.text, topic!);
                  },
                  text: 'Далее'),
            )
          ],
        )),
      ),
    );
  }

  Widget titles(TextEditingController controller, String text) {
    return Container(
      width: 305,
      height: 58,
      padding: EdgeInsets.only(left: 16, top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Color(0xff205692), width: 2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          hintText: text,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: TextStyle(
          fontFamily: 'ABeeZee',
          color: Color(0xff12408c),
        ),
      ),
    );
  }

  Widget themes(String text) {
    return Container(
      width: 305,
      height: 58,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff205692), width: 2),
          borderRadius: BorderRadius.circular(24.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(text),
          items: list_title.map(buildMenuItem).toList(),
          value: theme,
          isExpanded: true,
          icon: Image.asset('images/lists.png'),
          onChanged: (value) {
            setState(() {
              theme = value;
            });
          },
        ),
      ),
    );
  }

  Future<void> find_id(String kol) async {
    for (int i = 0; i < list.length; i++) {
      list_title.add(list[i].title.toString());
      if (theme == list[i].title) {
        topic = i + 1;
        break;
      }
    }
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(color: Colors.red),
      ));

  Future<void> Safekeys(String title, int theme) async {
    if (title.isNotEmpty && theme != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('key_title', title);
      await pref.setString('key_theme', theme.toString());

      print("$title,     $theme");
      Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) =>
              Create_Now(token: token, theme: topic.toString()))));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Заполните строки')));
    }
  }
}
