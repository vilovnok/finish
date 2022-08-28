import 'dart:convert';
import 'dart:io';
import 'package:flutter_finish/screens/show_request/projects/proj_description.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../../status_screen.dart';
import '../expertises/expertises.dart';


class Projects extends StatefulWidget {
  static String id = '/proj';
  String token;
  int number;
  Projects({Key? key, required this.token, required this.number})
      : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState(token, number);
}

class _ProjectsState extends State<Projects> {
  String token;
  int number;

  _ProjectsState(this.token, this.number);

  List<Data_of_user>? posts;

  List<String> list_title = [];
  List<String> list_theme = [];
  List<String> list_author = [];
  List<Data_of_user> listData = [];
  List<Data_of_user> list = [];
  List<String> list_image = [];

  Future<List<Data_of_user>> getData() async {
    String url = 'https://msofter.com/rosseti/public/api/suggestions/index';
    var apiresponse = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var jsonObject = json.decode(apiresponse.body);
    List<dynamic> data = (jsonObject as Map<String, dynamic>)['suggestions'];

    for (int i = 0; i < data.length; i++) {
      listData.add(Data_of_user.fromJson(data[i]));
    }
    return listData;
  }

  void getList_Data() {
    getData().then((value) {
      list = value;
      for (int i = 0; i < list.length; i++) {
        list_image.add(list[i].proposed_solution_image.toString());
        list_theme.add(list[i].topic_id.toString());
        list_author.add(list[i].author!['full_name'].toString());
        list_title.add(list[i].title.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    getList_Data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Image.asset('images/icon.png'))
        ],
        elevation: 0,
        backgroundColor: Color(0xffFAFBFD),
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('images/Vector.png')),
        title: Center(
          child: Text(
            'Проекты',
            style: TextStyle(
                fontFamily: 'Schyler',
                fontSize: 43.0,
                color: Color(0xff205692)),
          ),
        ),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(fontSize: 32.0),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ListView.builder(
                    itemCount: list_title.length,
                    itemBuilder: (context, i) {
                      return Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StatusScreen(),
                            ));
                          },
                          child: Card(
                            child: Container(
                              height: 124.0,
                              width: 336.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    list[i].existing_solution_image != null
                                        ? Image.network('${list_image[i]}')
                                        : Image.asset('images/car.png'),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              '${list_title[i]}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Schyler',
                                                  color: Color(0xff205692),
                                                  fontSize: 20),
                                            ),
                                            Container(
                                              height: 30,
                                            ),
                                            Text(
                                              '${list_author[i]}',
                                              style: TextStyle(
                                                  color: Color(0xffA1A1A1)),
                                            ),
                                            Text('${list_theme[i]}',
                                                style: TextStyle(
                                                    fontFamily: 'Schyler',
                                                    color: Color(0xff205692),
                                                    fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          }),
    );
  }

  final client = HttpClient();

  Future<void> getPosts() async {
    final json =
        await get('https://msofter.com/rosseti/public/api/suggestions/index')
            as Map<String, dynamic>;

    final data = json["suggestions"] as List<dynamic>;

    posts = data
        .map((dynamic e) => Data_of_user.fromJson(e as Map<String, dynamic>))
        .toList();
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
    // print("json ${json.runtimeType}");
    return json;
  }
}

class Data_of_user {
  String? title;
  String? existing_solution_video;
  String? proposed_solution_video;
  String? existing_solution_image;
  String? proposed_solution_image;

  int? id;
  int? topic_id;
  int? author_id;
  Map<String, dynamic>? author;
  String? existing_solution_text;
  String? proposed_solution_text;
  String? positive_effect;
  int? rating;

  Data_of_user(
      {required this.positive_effect,
      required this.proposed_solution_video,
      required this.proposed_solution_image,
      required this.existing_solution_video,
      required this.existing_solution_image,
      required this.proposed_solution_text,
      required this.existing_solution_text,
      required this.title,
      required this.author_id,
      required this.id,
      required this.topic_id,
      required this.author,
      required this.rating});

  factory Data_of_user.fromJson(Map<String, dynamic> json) =>
      _$Data_of_user(json);
}

Data_of_user _$Data_of_user(Map<String, dynamic> json) {
  return Data_of_user(
      proposed_solution_video: json['proposed_solution_video'],
      proposed_solution_image: json['proposed_solution_image'],
      existing_solution_video: json['existing_solution_video'],
      positive_effect: json['positive_effect'],
      existing_solution_image: json['existing_solution_image'],
      rating: json['rating'],
      proposed_solution_text: json['proposed_solution_text'],
      existing_solution_text: json['existing_solution_text'],
      author: json["author"],
      title: json['title'],
      id: json['id'],
      author_id: json["author_id"],
      topic_id: json["topic_id"]);
}

class Projects12 extends StatefulWidget {
  String token;
  int number;
  Projects12({Key? key, required this.token, required this.number})
      : super(key: key);

  @override
  State<Projects12> createState() => _Projects12State(token, number);
}

class _Projects12State extends State<Projects12> {
  String token;
  int number;
  Future<SuggList>? suggestionList;
  _Projects12State(this.token, this.number);

  @override
  void initState() {
    super.initState();
    suggestionList = getDataSugg(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => StatusScreen())));
              },
              child: Image.asset('images/icon.png'))
        ],
        elevation: 0,
        backgroundColor: Color(0xffFAFBFD),
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('images/Vector.png')),
        title: Center(
          child: Text(
            'Проекты',
            style: TextStyle(
                fontFamily: 'Schyler',
                fontSize: 43.0,
                color: Color(0xff205692)),
          ),
        ),
      ),
      body: FutureBuilder<SuggList>(
          future: suggestionList,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(fontSize: 32.0),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ListView.builder(
                    itemCount: snapshot.data?.suggestions.length,
                    itemBuilder: (context, index) {
                      return Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Proj_description(
                                full_name: snapshot.data?.suggestions[index]
                                        .author!['full_name'] ??
                                    '',
                                id: snapshot.data?.suggestions[index].id ?? 0,
                                number: number = index,
                                token: token,
                                author_id: snapshot
                                        .data?.suggestions[index].author_id ??
                                    0,
                                existing_solution_image: snapshot
                                        .data
                                        ?.suggestions[index]
                                        .existing_solution_image ??
                                    '',
                                existing_solution_text: snapshot
                                        .data
                                        ?.suggestions[index]
                                        .existing_solution_text ??
                                    '',
                                existing_solution_video: snapshot
                                        .data
                                        ?.suggestions[index]
                                        .existing_solution_video ??
                                    '',
                                positive_effect: snapshot.data
                                        ?.suggestions[index].positive_effect ??
                                    '',
                                proposed_solution_image: snapshot
                                        .data
                                        ?.suggestions[index]
                                        .proposed_solution_image ??
                                    '',
                                proposed_solution_text: snapshot
                                        .data
                                        ?.suggestions[index]
                                        .proposed_solution_text ??
                                    '',
                                proposed_solution_video: snapshot
                                        .data
                                        ?.suggestions[index]
                                        .proposed_solution_video ??
                                    '',
                              ),
                            ));
                          },
                          child: Card(
                            child: Container(
                              height: 124.0,
                              width: 336.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    snapshot.data?.suggestions[index]
                                                .existing_solution_image !=
                                            null
                                        ? Image.network(
                                            '${snapshot.data?.suggestions[index].existing_solution_image}')
                                        : Image.asset('images/car.png'),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              '${snapshot.data?.suggestions[index].title}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Schyler',
                                                  color: Color(0xff205692),
                                                  fontSize: 20),
                                            ),
                                            Container(
                                              height: 30,
                                            ),
                                            Text(
                                              '${snapshot.data?.suggestions[index].author!['full_name']}',
                                              style: TextStyle(
                                                  color: Color(0xffA1A1A1)),
                                            ),
                                            Text(
                                                '${snapshot.data?.suggestions[index].topic_id}',
                                                style: TextStyle(
                                                    fontFamily: 'Schyler',
                                                    color: Color(0xff205692),
                                                    fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          }),
    );
  }
}
