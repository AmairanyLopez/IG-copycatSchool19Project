import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'userprofile.dart';


class displaycomments extends StatelessWidget {
  var postID;
  var token;

  displaycomments(this.postID, this.token);

  List<dynamic> listofc;

  Future<List<dynamic>> getcomments(var post_id) async {
    var URL =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/${post_id}/comments";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var myposts_json = jsonDecode(response.body);
    print(post_id);
    print(myposts_json);
    return myposts_json;
  }

  var count;

  void justcall() async {
    listofc = await getcomments(postID);
    count = listofc.length;
    print(count);
  }

  Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < strings.length; i++){
      list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }



  @override
  Widget build(BuildContext context) {
justcall();
return getTextWidgets(listofc);
  }
}


class PostView extends StatefulWidget {
  var post;
  var token;
  var commentcontroller = TextEditingController();

  PostView(this.post, this.token);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  var userInfo;
  var userposts;
//make a comment
  Future<String> comments(var post_id, String comment) async {
    print(comment);
    var URL =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/${post_id}/comments?text=${comment}";
    var response = await http
        .post(URL, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    setState(() {
    });
  }

  List<dynamic> listofc;

  Future<List<dynamic>> getcomments(var post_id) async {
    var URL =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/${post_id}/comments";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    var myposts_json = jsonDecode(response.body);
    print(post_id);
    print(myposts_json);
    return myposts_json;
  }

  var count;

  void justcall(index) async {
    listofc = await getcomments(index);
    count = listofc.length;
    print(count);
  }

  //make a comment
  void commentx(var post_id) {
    var comment = widget.commentcontroller.text;
    comments(post_id, comment);
  }

  Future<List<dynamic>> getuserpost()async {
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/users/${widget.post["user_id"]}/posts";

    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    var posts_json = jsonDecode(response.body);
    return posts_json;
  }
  
  Future<Map<String, dynamic>> getuserinfo() async{
    print(widget.post["user_id"]);
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/users/${widget.post["user_id"]}";
    var response = await http
        .get(URL, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    var posts_json = jsonDecode(response.body);
    print(posts_json);
    return posts_json;
  }

  void stuffx(context) async {
    userInfo = await getuserinfo();
    userposts = await getuserpost();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => user_profile(userposts, userInfo, widget.token)));
  }
  void commentarios(context, index) async {
justcall(index);
count = listofc.length;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => commentspage(listofc, count)));
  }

  void like() async {
    var post_id = widget.post["id"];
    var URLl =
        "https://serene-beach-48273.herokuapp.com/api/v1/posts/${post_id}/likes";
    var response;
    widget.post["liked"]==false?
    response = await http.post(URLl, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"}):
    response = await http.delete(URLl, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});

    var myposts_json = jsonDecode(response.body);
    setState(() {
      if(widget.post["liked"] == false) {
        widget.post["liked"] = true;
        widget.post["likes_count"] += 1;
      }
      else{
        widget.post["liked"]=false;
        widget.post["liked_count"]-=1;
      }
    });
  }

  String likes() {
    String likes = widget.post["likes_count"].toString() + " likes";
    return likes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: widget.post
                            ['user_profile_image_url'] !=
                                null
                                ? NetworkImage(widget.post
                            ['user_profile_image_url'])
                                : NetworkImage(
                                widget.post['image_url'])),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(widget.post['user_email'], style: TextStyle(fontFamily: "Dosis", fontWeight: FontWeight.bold, fontSize: 15.0),),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {stuffx(context);},
                )
              ]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Image.network(
            widget.post['image_url'],
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: widget.post["liked"] ? Icon(Icons.favorite, color: Colors.pinkAccent,) : Icon(Icons.favorite_border, color: Colors.pinkAccent,),
                      onPressed: () {
                        setState(
                              () {
                            like();
                          },
                        );
                      } //change for a heart
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.insert_comment),
                    onPressed: () {}, //change to comment0
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Icon(Icons
                      .airplanemode_active) //change for paperPlane0
                ],
              ),
              Icon(Icons.bookmark) //change for bookmark0
            ],
          ),
        ),

        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
            Text(likes()) //style this
        ),new Ink(
            child: InkWell(
              onDoubleTap: (){commentarios(context, widget.post["id"]);},
              child:  Text(
                  "${widget.post["caption"]} (${widget.post["comments_count"]} comments)"),))
        //style this
        ,
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image:
                      new NetworkImage(widget.post['image_url'])),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: new TextField(
                  controller: widget.commentcontroller,
                  //decoration: new InputDecoration(
                  //border: InputBorder.none,
                  //hintText: "Add a comment...",
                  //),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: () {
                    commentx(widget.post["id"]);
                  })
            ],
          ),
        ),
        //Padding(
        //padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //child:
        //Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        //)//until here pasted
      ],
    );
  }
}


class commentspage extends StatefulWidget {
  var listofcomments;
  var count;
  commentspage(this.listofcomments, this.count);

  @override
  _commentspageState createState() => _commentspageState();
}

class _commentspageState extends State<commentspage> {
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
    return Scaffold(
      appBar: topBar,
      body:  ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(50.0),
        itemCount: widget.count,
        itemExtent: 100.0,
        itemBuilder: (BuildContext context, int index) {
          return Container( child: Column( children: [Text("${widget.listofcomments[index]["user_id"]} said:"),
            Text(widget.listofcomments[index]["text"]),
          ]),);
        },
      ) );
  }
}
