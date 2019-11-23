import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'mainscreen.dart';
import 'bottombar.dart';
import 'post.dart';


class user_profile extends StatefulWidget {
  var token;
  Map<String, dynamic> userInfo;
  List<dynamic> userPosts;

  user_profile(this.userPosts, this.userInfo, this.token);

  @override
  State<StatefulWidget> createState() {
    return _user_profile();
  }
}

class _user_profile extends State<user_profile> {
  List<dynamic> posts;
var bull=false;
var lengthx;
var biocontroller = TextEditingController();

  Future<List<dynamic>> getPosts(token) async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/posts";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var posts_json = jsonDecode(response.body);

    return posts_json;
  }

  Future<List<dynamic>> getmyPosts(token) async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/my_posts";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var myposts_json = jsonDecode(response.body);
    return myposts_json;
  }

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


  void pushsecondscreen(context) async {
    posts = await getPosts(widget.token);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(posts, widget.userPosts, widget.token)));
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topBar,
      body: Container(
        child: new Column(children: <Widget>[
          new Row(
            children: <Widget>[
              Material(
                type: MaterialType.circle,
                elevation: 4.0,
                color: Colors.transparent,
                child: Ink.image(
                  image: NetworkImage(widget.userInfo["profile_image_url"]),
                  fit: BoxFit.cover,
                  width: 120.0,
                  height: 120.0,
                  child: InkWell(onTap: () { }),
                ),
              ),
              Expanded(
                child: new Container(
                  height: 200.0,
                  padding: new EdgeInsets.only(left: 8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text(
                        widget.userInfo["email"],
                        style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                      new Ink(
                        child: InkWell(
                          onDoubleTap: (){},
                       child: Text(widget.userInfo["bio"], style: new TextStyle(color: Colors.pinkAccent, fontFamily: "Dosi", fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),)),
                    ],
                  ),
                ),
              ),
              //,,)
            ],
          ), new Container(
              decoration: new BoxDecoration(
                color: Colors.pink[50],
              ),
              height: 50.0, width: 500.0, child: Center( child: Text(" All Posts", style: TextStyle(fontFamily: "Pacifico", color: Colors.white, fontSize: 20.0),))
          ),Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(50.0),
            itemCount: widget.userPosts.length,
            itemExtent: 400.0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column( children: [
               Image(image: NetworkImage(widget.userPosts[index]["image_url"]),),Text( widget.userPosts[index]["caption"], style: TextStyle(fontFamily: "Dosi", fontSize: 20.0),),
              ]),);
            },
          ) )//Lista(myPosts, token)
        ]),
      ),
      bottomNavigationBar: BottomBar(widget.token));
  }
}
