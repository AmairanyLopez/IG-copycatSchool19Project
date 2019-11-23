import 'package:flutter/material.dart';
import 'profile.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'mainscreen.dart';


class postApic extends StatefulWidget {
  var token;

  postApic(this.token);

  @override
  State<StatefulWidget> createState() {
    return _postApic(token);
  }
}

class _postApic extends State<postApic> {
  var token;

  _postApic(this.token);

  var caption = "test";
  List<dynamic> posts;
  List<dynamic> nposts;

  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<List<dynamic>> getPosts(token) async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/posts";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var posts_json = jsonDecode(response.body);
    return posts_json;
  }

  Future<Response> Postpic() async {
    FormData formData = FormData.from(
        {"caption": "they forgot my cookie", "image": UploadFileInfo(_image, _image.path)});
    var response = await Dio().post(
        "https://serene-beach-48273.herokuapp.com/api/v1/posts",
        data: formData,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
    nposts = await getPosts(token);
    setState(() {
      posts = nposts;
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          onPressed: () {
            Postpic();
          },
          child: Icon(
            Icons.send,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getmyInfo(token) async {
  var URL = "https://serene-beach-48273.herokuapp.com/api/v1/my_account";

  var response = await http
      .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
  var posts_json = jsonDecode(response.body);
  return posts_json;
}

class BottomBar extends StatelessWidget {
  var my_posts;
  var token;

  BottomBar(this.token);

  Future<List<dynamic>> getPosts(token) async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/posts";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var posts_json = jsonDecode(response.body);
    return posts_json;
  }

  //get my posts here
  Future<List<dynamic>> getmyPosts(token) async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/my_posts";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var myposts_json = jsonDecode(response.body);
    return myposts_json;
  }

  void stuffx(context) async {
    var myInfo = await getmyInfo(token);
    my_posts = await getmyPosts(token);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => my_profile(my_posts, myInfo, token)));
  }

  void pushpostpic(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => postApic(token)));  }

  void pushmain(context) async {
    var posts= await getPosts(token);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainScreen(posts, my_posts, token)));
  }

  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: () {pushmain(context);},
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.add_box,
            ),
            onPressed: () {
              pushpostpic(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.account_box,
            ),
            onPressed: () {
              stuffx(context);
            },
          ),
        ],
      ),
    );
  }
}
