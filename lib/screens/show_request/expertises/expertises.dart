import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../status_screen.dart';
import '../projects/projects.dart';
import 'allow_or_not.dart';


class SuggList {
  List<Sugg> suggestions;
  SuggList({required this.suggestions});

  factory SuggList.fromJson(Map<String, dynamic> json) {
    var sugList = json['suggestions'] as List;

    List<Sugg> sList = sugList.map((i) => Sugg.fromJson(i)).toList();

    return SuggList(suggestions: sList);
  }
}

class Sugg {
  final String? title;
  final int? topic_id;
  final int? author_id, id;
//
  final String? existing_solution_image;
  final String? existing_solution_text;
  final String? existing_solution_video;
//
  final String? proposed_solution_image;
  final String? proposed_solution_text;
  final String? proposed_solution_video;
//

  final int? status_id;
  final String? positive_effect;
  final Map<String, dynamic>? author;
  final List<dynamic>? comments;

  Sugg(
      {required this.id,
      required this.author_id,
      required this.existing_solution_text,
      required this.existing_solution_video,
      required this.proposed_solution_image,
      required this.proposed_solution_text,
      required this.proposed_solution_video,
      required this.topic_id,
      required this.existing_solution_image,
      required this.positive_effect,
      required this.comments,
      required this.status_id,
      
      required this.title,
      required this.author});

  factory Sugg.fromJson(Map<String, dynamic> json) {
    return Sugg(
      positive_effect: json['positive_effect'] as String,
      status_id: json['status_id'] as int,
      title: json['title'] as String,
      author: json['author'],
      comments: json['comments'],
      existing_solution_image: json['existing_solution_image'] as String,
      topic_id: json['topic_id'] as int,
      existing_solution_text: json['existing_solution_text'] as String,
      existing_solution_video: json['existing_solution_video'] as String,
      proposed_solution_image: json['proposed_solution_image'] as String,
      proposed_solution_text: json['proposed_solution_text'] as String,
      proposed_solution_video: json['proposed_solution_video'] as String,
      author_id: json['author_id'] as int,
      id: json['id'] as int,
      
    );
  }
}

Future<SuggList> getDataSugg(String token) async {
  const url = 'http://msofter.com/rosseti/public/api/suggestions/index';
  final response = await http.get(
    Uri.parse(url),
    headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    return SuggList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}

class Exper extends StatefulWidget {
  Exper({Key? key, required this.token, required this.number})
      : super(key: key);
  String token;
  int number;

  @override
  State<Exper> createState() => _ExperState(token, number);
}

class _ExperState extends State<Exper> {
  String token;
  int number;

  _ExperState(this.token, this.number);

  Future<SuggList>? suggestionList;

  @override
  void initState() {
    suggestionList = getDataSugg(token);
    super.initState();
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
                              builder: (context) => Allow_or_not(
                                full_name: snapshot
                                        .data?.suggestions[index].author!['full_name'] ??
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

class Expertises extends StatefulWidget {
  static String id = '/proj';
  String token;
  int number;
  Expertises({Key? key, required this.token, required this.number})
      : super(key: key);

  @override
  State<Expertises> createState() => _ExpertisesState(token, number);
}

class _ExpertisesState extends State<Expertises> {
  String token;
  int number;

  _ExpertisesState(this.token, this.number);

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
                            // Navigator.of(context).push(MaterialPageRoute(
                            // builder: (context) => Allow_or_not(
                            // data_of_user: posts![i],
                            // number: number = i,
                            // token: token,
                            // ),
                            // ));
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
