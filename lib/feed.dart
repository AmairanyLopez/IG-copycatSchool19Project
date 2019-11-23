import 'package:flutter/material.dart';
import 'post.dart';

class Lista extends StatefulWidget {
  List<dynamic> posts;
  var token;

  Lista(this.posts, this.token);

  @override
  State<StatefulWidget> createState() {
    return _lista(posts, token);
  }
}

class _lista extends State<Lista> {
  List<dynamic> posts;
  var token;

  _lista(this.posts, this.token);

  Map<String, dynamic> userInfo;


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var count = posts.length;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) => index == 0
          ? new Container()
          : PostView(posts[index], token)
    );
  }
}
