import 'dart:io';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import '../../models/btn_route.dart';

import '../../models/part_main_1.dart';
import '../../models/part_main_2.dart';
import 'create_will.dart';

class Create_Need extends StatefulWidget {
  static String id = '/create_need';

  String theme;
  String token;

  Create_Need({Key? key, required this.theme, required this.token})
      : super(key: key);

  @override
  State<Create_Need> createState() => _Create_NeedState(token, theme);
}

class _Create_NeedState extends State<Create_Need> {
  TextEditingController _controller_need_text = TextEditingController();
  String token;
  String theme;

  _Create_NeedState(this.token, this.theme);

  late Future<void> _initializeVideoPlayerFuture;

  bool _validate = false;
  VideoPlayerController controller_need_video =
      VideoPlayerController.network('dataSource');
  final _addFormKey = GlobalKey<FormState>();
  File? _video;
  File? _image;
  final picker = ImagePicker();
  String? text_now;
  String? text_need;
  String? title;
  String? video_now;
  String? image_now;

  @override
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString('key_title');

      text_now = pref.getString('key_text_now');
      image_now = pref.getString('key_image_now');

      video_now = pref.getString('key_video_now');
    });
  }

  Future getVideo() async {
    final video = await picker.getVideo(source: ImageSource.gallery);
    setState(() {
      if (video != null) {
        _video = File(video.path);
        controller_need_video = VideoPlayerController.file(_video!)
          ..initialize().then((_) {
            setState(() {});
          });
        controller_need_video.play();
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeVideoPlayerFuture = controller_need_video.initialize();
    controller_need_video.setLooping(true);
    getData();
    print(theme);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    controller_need_video.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Part_for_video1(
                  text: 'Создать',
                ),
                Part_for_video2(
                  text: "надо",
                  controller: _controller_need_text,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorText: _validate ? 'заполни его' : null,
                  ),
                ),
                getWidget(),
                SizedBox(
                  height: 31.0,
                ),
                Btn_R(
                    onPressed: () {
                      Safekeys(_controller_need_text.text, _image!.path,
                          _video!.path);

                      setState(() {
                        _controller_need_text.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                        _controller_need_text.clear();
                        controller_need_video.pause();
                      });
                    },
                    text: 'Дальше'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> Safekeys(
      String text_need, String image_need, String video_need) async {
    if (text_need.isNotEmpty) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('key_text_need', text_need);
      await pref.setString('key_image_need', image_need);
      await pref.setString('key_video_need', video_need);

      Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => Create_Will(
                token: token,
                theme: theme,
              ))));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Заполните данные')));
    }
  }

  Widget getWidget() {
    return Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 17.0, bottom: 23.0),
                child: Text(
                  'Добавьте фото или видео',
                  style: TextStyle(
                    fontFamily: 'ABeeZee',
                    color: Color(0xFF205692),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 5,
                    color: Colors.red,
                    child: controller_need_video != null
                        ? FlatButton(
                            onPressed: () {
                              setState(() {
                                // If the video is playing, pause it.
                                if (controller_need_video.value.isPlaying) {
                                  controller_need_video.pause();
                                } else {
                                  // If the video is paused, play it.
                                  controller_need_video.play();
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
                                      return AspectRatio(
                                        aspectRatio: controller_need_video
                                            .value.aspectRatio,
                                        child:
                                            VideoPlayer(controller_need_video),
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
                            height: 51.0,
                            width: 91.0,
                            color: Colors.red,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: Card(
                      elevation: 5,
                      color: Colors.amber,
                      child: _image != null
                          ? Container(
                              height: 51,
                              width: 92,
                              child: Expanded(child: Image.file(_image!)),
                            )
                          : Container(
                              height: 51,
                              width: 91,
                            ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      getVideo();
                    },
                    icon: Icon(
                      Icons.video_collection,
                      size: 43,
                    ),
                  ),
                  IconButton(
                      onPressed: getImage,
                      icon: Icon(
                        Icons.photo,
                        size: 43,
                      )),
                ],
              )
            ],
          ),
        ));
  }

  void SafeKeys_image(String image_url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('key_image_need', image_url);
  }

  void SafeKeys_video(String image_url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('key_video_need', image_url);
  }
}
