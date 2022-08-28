



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/btn_route.dart';
import '../../models/part_main_1.dart';
import '../../models/part_main_2.dart';
import '../main_page.dart';
import '../status_screen.dart';
import 'empty.dart';

class Create_Will extends StatefulWidget {
  static String id = '/create_will';
  String token;
  String theme;

  Create_Will({
    Key? key,
    required this.theme,
    required this.token,
  }) : super(key: key);
  @override
  State<Create_Will> createState() => _Create_WillState(
        token,
        theme,
      );
}

class _Create_WillState extends State<Create_Will> {
  String token;

  _Create_WillState(this.token, this.theme);
  String? title;
  String? theme;
  String? text_now;
  String? text_need;
  String? image_now;
  String? image_need;
  String? video_now;
  String? video_need;

  TextEditingController _controller_will_text = TextEditingController();

  bool _validate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    print('theme $theme');
    print('title $title');
  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString('key_title');
      // theme = pref.getString('key_theme');
      text_now = pref.getString('key_text_now');
      text_need = pref.getString('key_text_need');
      image_now = pref.getString('key_image_now');
      image_need = pref.getString('key_image_need');
      video_now = pref.getString('key_video_now');
      video_need = pref.getString('key_video_need');

      UserInfo.image_needString = image_need;
      UserInfo.image_nowString = image_now;
      UserInfo.video_needString = video_need;
      UserInfo.video_nowString = video_now;

      UserInfo.text_needString = text_need;
      UserInfo.text_nowString = text_now;
      UserInfo.titleString = title;
      UserInfo.themeString = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 68.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Part_for_video1(text: 'Создать'),
                Part_for_video2(
                  controller: _controller_will_text,
                  text: "будет",
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorText: _validate ? 'заполни его' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Btn_R(
                      onPressed: () {
                        // Map<String, String> body = {
                        //   'video': '_titleController.text'
                        // };
                        // addImage(
                        //     body: body,
                        //     imagePath_now: image_now!,
                        //     videoPath_now: video_now!,
                        //     title: title!,
                        //     theme: theme!,
                        //     imagePath_need: image_need!,
                        //     videoPath_need: video_need!,
                        //     text_positive:
                        //         _controller_will_text.text.toString(),
                        //     text_now: text_now!,
                        //     text_need: text_need!);
                        UserInfo.text_poziString = _controller_will_text.text;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => Empty(
                                text_now: text_now.toString(),
                                image_now: image_now.toString(),
                                video_now: video_now.toString(),
                                image_need: image_need.toString(),
                                video_need: video_need.toString(),
                                text_need: text_need.toString(),
                                text_positive: _controller_will_text.text,
                                title: title.toString(),
                                theme: theme.toString()))));
                      },
                      text: 'Готово'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> addImage({
    required Map<String, String> body,
    required String imagePath_now,
    required String videoPath_now,
    required String title,
    required String theme,
    required String imagePath_need,
    required String videoPath_need,
    required String text_positive,
    required String text_now,
    required String text_need,
  }) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    String addimageUrl =
        'https://msofter.com/rosseti/public/api/suggestions/store';

    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields['topic_id'] = theme
      ..headers.addAll(headers)
      ..fields['existing_solution_text'] = text_now
      ..fields['proposed_solution_text'] = text_need
      ..fields['positive_effect'] = text_positive
      ..fields['title'] = title
      ..files.add(await http.MultipartFile.fromPath(
          'proposed_solution_video', videoPath_need))
      ..files.add(await http.MultipartFile.fromPath(
          'proposed_solution_image', imagePath_need))
      ..files.add(await http.MultipartFile.fromPath(
          'existing_solution_video', videoPath_now))
      ..files.add(await http.MultipartFile.fromPath(
          'existing_solution_image', imagePath_now));

    var response = await request.send();

    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Safekeys(_controller_will_text.text);
      print('IM good');
      return true;
    } else {
      print('bad');
      print('Я не могу }{ create_descript');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      return false;
    }
  }

  void Safekeys(String text_will) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('key_text_will', text_will);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => MainPage())));
  }
}
