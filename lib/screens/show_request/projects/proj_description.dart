import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';


import 'package:http/http.dart' as http;

import '../../../models/btn_route.dart';
import '../../../models/part_main_1.dart';
import '../../status_screen.dart';
import '../chat.dart';


class Proj_description extends StatefulWidget {
  String token,
      positive_effect,
      existing_solution_text,
      proposed_solution_text,
      proposed_solution_image,
      proposed_solution_video,
      existing_solution_image,
      full_name,
      existing_solution_video;
  int number, author_id, id;
  Proj_description(
      {Key? key,
      required this.number,
      required this.id,
      required this.author_id,
      required this.existing_solution_image,
      required this.existing_solution_video,
      required this.proposed_solution_image,
      required this.proposed_solution_video,
      required this.proposed_solution_text,
      required this.positive_effect,
      required this.existing_solution_text,
      required this.full_name,
      required this.token})
      : super(key: key);

  @override
  State<Proj_description> createState() => _Proj_descriptionState(
      full_name,
      number,
      author_id,
      token,
      id,
      existing_solution_image,
      existing_solution_text,
      existing_solution_video,
      proposed_solution_image,
      proposed_solution_text,
      proposed_solution_video,
      positive_effect);
}

class _Proj_descriptionState extends State<Proj_description> {
  int number, author_id, id;
  String token,
      positive_effect,
      existing_solution_text,
      proposed_solution_text,
      proposed_solution_image,
      proposed_solution_video,
      existing_solution_image,
      existing_solution_video,
      full_name;
  _Proj_descriptionState(
      this.full_name,
      this.number,
      this.author_id,
      this.token,
      this.id,
      this.existing_solution_image,
      this.existing_solution_text,
      this.existing_solution_video,
      this.proposed_solution_image,
      this.proposed_solution_text,
      this.proposed_solution_video,
      this.positive_effect);
  late Future<void> _initializeVideoPlayerFuture;
  late Future<void> _initializeVideoPlayerFuture2;

  File? video;

  String filepath1 = '';
  String filepath2 = '';
  double value = 0;

  int author_1d = 0;

  VideoPlayerController controller = VideoPlayerController.asset('dataSource');
  VideoPlayerController controller2 = VideoPlayerController.asset('dataSource');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserInfo.idString = id;
    UserInfo.nameString = full_name;

    getVideo(existing_solution_video.toString());
    getVideo2(existing_solution_video.toString());
    // print(" Image: ${existing_solution_image}");
    // print('Video ${existing_solution_video}');
    _initializeVideoPlayerFuture = controller.initialize();
    _initializeVideoPlayerFuture2 = controller2.initialize();
    controller.setLooping(true);
    controller2.setLooping(true);
    RemoveRaiting();

    author_1d = author_id;
    print("number $number");
    print('proposed_solution_text $proposed_solution_text');
    print('proposed_solution_image $proposed_solution_image');
    print('proposed_solution_video $proposed_solution_video ');
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    controller.dispose();
    controller2.dispose();

    super.dispose();
  }

  void getVideo(String path) {
    controller = VideoPlayerController.network(path);
  }

  void getVideo2(String path) {
    controller2 = VideoPlayerController.network(path);
  }

  Future RemoveRaiting() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<bool> addRaiting(
      {required String value, required String suggestion_id}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    String addRaitingUrl =
        'https://msofter.com/rosseti/public/api/suggestions/rating/store';
    var request = http.MultipartRequest('POST', Uri.parse(addRaitingUrl))
      ..headers.addAll(headers)
      ..fields['value'] = value
      ..fields['suggestion_id'] = suggestion_id;
    var response = await request.send();

    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Safekeys(value);
      print('IM good');
      return true;
    } else {
      print("bad");
      print('Я не могу }{ create_descript');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      return false;
    }
  }

  void Safekeys(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('key_value', value);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            Chat(token: token, author_id: author_id, number: number)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: Part_for_video1(
                text: 'Создать',
              ),
            ),
            widget_now(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: widget_need(),
            ),
            widget_will()
          ],
        ),
      ),
    );
  }

  Widget widget_now() {
    return Column(
      children: <Widget>[
        Text(
          'Сейчас так:',
          style: TextStyle(
              fontFamily: 'ABeeZee',
              fontWeight: FontWeight.w400,
              color: Color(0xff205692),
              fontSize: 20.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              width: 305,
              height: 292,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                child: Text(
                  '${existing_solution_text}',
                  style: TextStyle(
                    fontFamily: 'ABeeZee',
                    color: Color(0xff12408c),
                  ),
                  maxLines: 100,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Card(
                  child: existing_solution_image != null
                      ? Container(
                          width: 92,
                          height: 52,
                          child: Expanded(
                            child: Image.network(
                              '${existing_solution_image}',
                              width: 92,
                            ),
                          ),
                        )
                      : Container(
                          height: 52,
                          width: 92,
                          color: Colors.red,
                        )),
              Card(
                  child: existing_solution_video != null
                      ? FlatButton(
                          onPressed: () {
                            setState(() {
                              // If the video is playing, pause it.
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                // If the video is paused, play it.
                                controller.play();
                              }
                            });
                          },
                          child: Container(
                            width: 92,
                            height: 52,
                            child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    // If the VideoPlayerController has finished initialization, use
                                    // the data it provides to limit the aspect ratio of the video.
                                    return AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      // Use the VideoPlayer widget to display the video.
                                      child: VideoPlayer(controller),
                                    );
                                  } else {
                                    // If the VideoPlayerController is still initializing, show a
                                    // loading spinner.
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })),
                          ),
                        )
                      : Container(
                          height: 52,
                          width: 92,
                          color: Colors.amber,
                        )),
            ],
          ),
        ),
      ],
    );
  }

  Widget widget_need() {
    return Column(
      children: <Widget>[
        Text(
          'Надо так:',
          style: TextStyle(
              fontFamily: 'ABeeZee',
              fontWeight: FontWeight.w400,
              color: Color(0xff205692),
              fontSize: 20.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              width: 305,
              height: 292,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                child: Text(
                  '${proposed_solution_text}',
                  style: TextStyle(
                    fontFamily: 'ABeeZee',
                    color: Color(0xff12408c),
                  ),
                  maxLines: 100,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Card(
                  child: proposed_solution_image != null
                      ? Container(
                          height: 52,
                          width: 92,
                          child: Expanded(
                            child: Image.network(
                              proposed_solution_image.toString(),
                              width: 92,
                            ),
                          ),
                        )
                      : Container(
                          width: 92,
                          height: 52,
                          color: Colors.red,
                        )),
              Card(
                  child: proposed_solution_video != null
                      ? FlatButton(
                          onPressed: () {
                            setState(() {
                              // If the video is playing, pause it.
                              if (controller2.value.isPlaying) {
                                controller2.pause();
                              } else {
                                // If the video is paused, play it.
                                controller2.play();
                              }
                            });
                          },
                          child: Container(
                            width: 92,
                            height: 52,
                            child: FutureBuilder(
                                future: _initializeVideoPlayerFuture2,
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return AspectRatio(
                                      aspectRatio:
                                          controller2.value.aspectRatio,
                                      child: VideoPlayer(controller2),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })),
                          ),
                        )
                      : Container(
                          height: 52,
                          width: 92,
                          color: Colors.amber,
                        )),
            ],
          ),
        ),
      ],
    );
  }

  Widget widget_will() {
    return Column(
      children: [
        Text(
          'И тогда будет так:',
          style: TextStyle(
              fontFamily: 'ABeeZee',
              fontWeight: FontWeight.w400,
              color: Color(0xff205692),
              fontSize: 20.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              width: 305,
              height: 292,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                child: Text(
                  '${positive_effect}',
                  style: TextStyle(
                    fontFamily: 'ABeeZee',
                    color: Color(0xff12408c),
                  ),
                  maxLines: 100,
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 140.0, bottom: 10),
              child: Text(
                'Оцените проект:',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            RatingBar.builder(
              itemSize: 46,
              itemPadding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              minRating: 1,
              updateOnDrag: true,
              onRatingUpdate: (rating) => setState(
                () {
                  value = rating;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Btn_R(
                onPressed: () {
                  addRaiting(
                      value: value.toString(), suggestion_id: id.toString());
                      controller2.pause();controller.pause();setState(() {
                        
                      });
                },
                text: "Обсудить"),
            SizedBox(
              height: 30,
            ),
          ],
        )
      ],
    );
  }
}
