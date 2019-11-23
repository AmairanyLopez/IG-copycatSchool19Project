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

class postApropic extends StatefulWidget {
  var token;

  postApropic(this.token);

  @override
  State<StatefulWidget> createState() {
    return _postApropic(token);
  }
}

class _postApropic extends State<postApropic> {
  File _image;
  var token;

  _postApropic(this.token);

  var caption = "test";

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<Response> Postpic() async {
    FormData formData =
    FormData.from({"image": UploadFileInfo(_image, _image.path)});
    var response = await Dio().patch(
        "https://serene-beach-48273.herokuapp.com/api/v1/my_account/profile_image",
        data: formData,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
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

class my_profile extends StatefulWidget {
  var token;
  Map<String, dynamic> myInfo;
  List<dynamic> myPosts;

  my_profile(this.myPosts, this.myInfo, this.token);

  @override
  State<StatefulWidget> createState() {
    return _my_profile();
  }
}

class _my_profile extends State<my_profile> {
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

  final rightSection = Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text(
            "Following:",
            style: new TextStyle(color: Colors.pinkAccent, fontSize: 12.0),
          ),
          new CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 10.0,
            child: new Text(
              "15",
              style: new TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          )
        ],
      ));

  void _biodialog(){
    showDialog(
        context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Center(child: Text("Updating your Bio")),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child:  TextField(
                controller: biocontroller,
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child:Text("yes update it!"),
            onPressed: (){postbio();},
          ),
          FlatButton(
              child: Text("Cancel"),
              onPressed: (){Navigator.of(context).pop();}
          )

        ],);
    });
  }

  void pushpostpic(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => postApropic(widget.token)));
  }

  void pushsecondscreen(context) async {
    posts = await getPosts(widget.token);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(posts, widget.myPosts, widget.token)));
  }

  void postbio() async {
    var newbio = biocontroller.text;
    var URL = "https://serene-beach-48273.herokuapp.com/api/v1/my_account?bio=${newbio}";

    var response = await http
        .patch(URL, headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    var posts_json = jsonDecode(response.body);
    print(posts_json);
    setState(() {

    });
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
                elevation: 4.0,
                shape: CircleBorder(),
                child: Ink.image(
                  image: NetworkImage(widget.myInfo["profile_image_url"]),
                  fit: BoxFit.fill,
                  width: 120.0,
                  height: 120.0,
                  child: InkWell(onTap: () {
                    pushpostpic(context);
                  }),
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
                        "Amairany Lopez",
                        style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0, fontFamily: "Dosi",
                        ),
                      ),
                      new Ink(
                        child: InkWell(
                          onDoubleTap: (){_biodialog();},
                       child: Text(widget.myInfo["bio"], style: new TextStyle(color: Colors.pinkAccent, fontFamily: "Dosi"),
                      ),)),
                    ],
                  ),
                ),
              ),
              rightSection
              //,,)
            ],
          ),new Container(
              decoration: new BoxDecoration(
                color: Colors.pink[50],
              ),
              height: 50.0, width: 500.0, child: Center( child: Text("My Posts", style: TextStyle(fontFamily: "Pacifico", color: Colors.white, fontSize: 20.0),))
          ), Expanded( child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(50.0),
            itemCount: widget.myPosts.length,
            itemExtent: 400.0,
            itemBuilder: (BuildContext context, int index) {
              return Container( child: Column( children: [
               Image(image: NetworkImage(widget.myPosts[index]["image_url"]),),Text( widget.myPosts[index]["caption"]),
              ]),);
            },
          ) )//Lista(myPosts, token)
        ]),
      ),
      bottomNavigationBar: BottomBar(widget.token));
  }
}
