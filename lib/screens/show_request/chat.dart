import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/part_main_1.dart';
import '../status_screen.dart';

class Chat extends StatefulWidget {
  Chat({
    Key? key,
    required this.token,
    required this.author_id,
    required this.number,
  }) : super(key: key);
  String token;
  int author_id;
  int number;

  @override
  State<Chat> createState() => _ChatState(token, author_id, number);
}

class _ChatState extends State<Chat> {
  String token;
  int author_id;
  int number;

  List<Data_comments> listData = [];
  List<Data_comments> list = [];

  List<String> list_text = [];
  List<String> list_id = [];
  List<String> list_name = [];
  TextEditingController _textcontroller = TextEditingController();

  _ChatState(
    this.token,
    this.author_id,
    this.number,
  );

  Future<List<Data_comments>> getData() async {
    String url = 'https://msofter.com/rosseti/public/api/suggestions/index';
    var apiresponse = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var jsonObject = json.decode(apiresponse.body);
    List<dynamic> data =
        (jsonObject as Map<String, dynamic>)['suggestions'][number]['comments'];

    for (int i = 0; i < data.length; i++) {
      listData.add(Data_comments.fromJson(data[i]));
    }

    return listData;
  }

  @override
  void initState() {
    super.initState();
    getList_name();

    print("Token  $token");
    print("Author_id  $author_id");
    print("nuuber $number");
    print('id ${UserInfo.idString}');
    print('full_name ${UserInfo.nameString}');
  }

  void getList_name() {
    getData().then((value) {
      list = value;
      for (int i = 0; i < list.length; i++) {
        list_name.add(list[i].user!['full_name'].toString());
        list_text.add(list[i].text.toString());
      }

      setState(() {});
    });
  }

  Future<void> getMyRequest(String text) async {
    if (_textcontroller.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse(
              'https://msofter.com/rosseti/public/api/suggestions/comment/store'),
          body: ({'suggestion_id': UserInfo.idString.toString(), 'text': text}),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // list_text.add(text);

        print(body['success']);
      } else {
        print('your post is false');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Part_for_video1(text: 'Обсуждение'),
            ),
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text(
                          'Loading...',
                          style: TextStyle(fontSize: 32.0),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: ListView.builder(
                        itemCount: list_name.length,
                        itemBuilder: ((context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: list_name[i] == UserInfo.nameString
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 160,
                                height: 70,
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(30),
                                  color: list_name[i] == UserInfo.nameString
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: list_name[i] ==
                                                  UserInfo.nameString
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              list_name[i] == 'admin'
                                                  ? UserInfo.nameString
                                                  : list_name[i],
                                              style: TextStyle(
                                                  color: list_name[i] ==
                                                          UserInfo.nameString
                                                      ? Colors.white
                                                      : Colors.grey),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              list_text[i].toString(),
                                              style: TextStyle(
                                                  color: list_name[i] ==
                                                          UserInfo.nameString
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(color: Color.fromRGBO(158, 158, 158, 1), child: btn33()),
          ],
        ),
      ),
    );
  }

  Widget btn33() {
    return Container(
      color: Colors.white,
      height: 100,
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ваше сообщение',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                    onSubmitted: (text) {},
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    getMyRequest(_textcontroller.text);
                    if (_textcontroller.text.isNotEmpty) {
                      list_text.add(_textcontroller.text);
                      list_name.add(UserInfo.nameString);
                    } else {}
                    _textcontroller.text = '';
                  },
                  child: Container(
                    width: 48,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(66),
                      color: Color.fromARGB(255, 45, 16, 162),
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class Data_comments {
  int? id;
  String? text;
  int? user_id;
  int? suggestion_id;

  int? you;
  Map? user;
  Data_comments(
      {required this.id,
      required this.suggestion_id,
      required this.text,
      required this.user,
      required this.user_id,
      required this.you});
  factory Data_comments.fromJson(Map<String, dynamic> json) =>
      _$Data_comments(json);
}

Data_comments _$Data_comments(Map<String, dynamic> json) {
  return Data_comments(
      id: json['id'],
      text: json['text'],
      suggestion_id: json['suggestion_id'],
      user: json['user'],
      user_id: json['user_id'],
      you: json["you"]);
}
