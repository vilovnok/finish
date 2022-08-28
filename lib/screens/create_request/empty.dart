
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main_page.dart';
import '../status_screen.dart';


class Empty extends StatefulWidget {
  Empty(
      {Key? key,
      required this.text_now,
      required this.image_now,
      required this.video_now,
      required this.image_need,
      required this.video_need,
      required this.text_need,
      required this.text_positive,
      required this.title,
      required this.theme})
      : super(key: key);
  String text_now,
      image_now,
      video_now,
      image_need,
      video_need,
      text_need,
      text_positive,
      title,
      theme;
  @override
  State<Empty> createState() => _EmptyState(
      this.text_now,
      this.image_now,
      this.video_now,
      this.image_need,
      this.video_need,
      this.text_need,
      this.text_positive,
      this.theme,
      this.title);
}

class _EmptyState extends State<Empty> {
  String text_now,
      image_now,
      video_now,
      image_need,
      video_need,
      text_need,
      text_positive,
      title,
      theme;

  _EmptyState(
      this.text_now,
      this.image_now,
      this.video_now,
      this.image_need,
      this.video_need,
      this.text_need,
      this.text_positive,
      this.title,
      this.theme);

  void onPressed() {
    Map<String, String> body = {'video': '_titleController.text'};
    addImage(
        body: body,
        imagePath_now: image_now,
        videoPath_now: video_now,
        title: title,
        theme: theme,
        imagePath_need: image_need,
        videoPath_need: video_need,
        text_positive: text_positive,
        text_now: text_now,
        text_need: text_need);
  }

  @override
  void initState() {
    onPressed();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.black)),
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
      'Authorization': 'Bearer ${UserInfo.tokenString}',
      'Content-Type': 'multipart/form-data'
    };
    String addimageUrl =
        'https://msofter.com/rosseti/public/api/suggestions/store';

    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields['topic_id'] = title
      ..headers.addAll(headers)
      ..fields['existing_solution_text'] = text_now
      ..fields['proposed_solution_text'] = text_need
      ..fields['positive_effect'] = text_positive
      ..fields['title'] = theme
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => MainPage())));
      Safekeys(text_positive);
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

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: ((context) => MainPage())));
  }
}
