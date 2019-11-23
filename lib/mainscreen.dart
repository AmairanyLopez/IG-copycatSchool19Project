import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'profile.dart';
import 'post.dart';
import 'feed.dart';
import 'bottombar.dart';

class MainScreen extends StatefulWidget {
  List<dynamic> posts;
  List<dynamic> my_posts;
  var token;
  var bull = true;
  var caption = "testing";

  MainScreen(this.posts, this.my_posts, this.token);

  Future<List<dynamic>> getPosts(token) async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/posts";
    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var posts_json = jsonDecode(response.body);
    return posts_json;
  }

  @override
  State<StatefulWidget> createState() {
    return _MainScreen(posts, my_posts, token);
  }
}

class _MainScreen extends State<MainScreen> {
  List<dynamic> posts;
  List<dynamic> my_posts;
  var token;
  var bull = true;
  var caption = "testing";
  Map<String, dynamic> myInfo;

  _MainScreen(this.posts, this.my_posts, this.token);

  final topBar = new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    leading: new Icon(Icons.camera_alt),
    title: SizedBox(
        height: 35.0, child: Text("Welcome", style: TextStyle(fontFamily: "Pacifico", color: Colors.pinkAccent, fontSize: 30.0),)),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(Icons.send),
      )
    ],
  );





  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topBar,
      body: instabody(posts, my_posts, bull, token),
      bottomNavigationBar: new Container(
        color: Colors.white,
        height: 50.0,
        alignment: Alignment.center,
        child: BottomBar(token)
      ));
  }
}

class instabody extends StatelessWidget {
  List<dynamic> posts;
  List<dynamic> my_posts;
  var bull = true;
  var token;

  instabody(this.posts, this.my_posts, this.bull, this.token);

  @override
  Widget build(BuildContext context) {
//what will be displayed on second screen
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          bull == true
              ? Flexible(child: new Lista(posts, token))
              : Flexible(child: new Lista(my_posts, token))
        ]);
  }
}

class instabody2 extends StatelessWidget {
  List<dynamic> posts;
  var bull = true;
  var token;

  instabody2(this.posts,  this.bull, this.token);

  @override
  Widget build(BuildContext context) {
//what will be displayed on second screen
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
               Flexible(child: new Lista(posts, token))
        ]);
  }
}
