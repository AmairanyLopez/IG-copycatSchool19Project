import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'mainscreen.dart';

class MyHomePage extends StatelessWidget {
  var usercontroller = TextEditingController();
  var passcontroller = TextEditingController();

  void stuff(context) async {
    var token = await login();
    var allPosts = await getPosts(token);
    var myPosts = await getmyPosts(token);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(allPosts, myPosts, token)));
  }

  Future<String> login() async {
    var user = usercontroller.text;
    var password = passcontroller.text;
    var URL =
        "https://serene-beach-48273.herokuapp.com/api/login?username=${user}&password=${password}";
    var response = await http.get(URL);
    var token =
        "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0MH0.G7H0xANXLW8Rzkr79dgxTyHGgCuAmuH3ghBa9YHIRhM"; //jsonDecode(response.body)["token"];
    return token;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login: "),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: usercontroller),
            TextField(controller: passcontroller),
            RaisedButton(
                child: Text('Login'),
                onPressed: () {
                  stuff(context); //something goes here when pressed
                })
          ],
        ),
      ),
    );
  }
}

