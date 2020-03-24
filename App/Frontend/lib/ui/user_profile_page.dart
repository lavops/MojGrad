import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:post/models/fullPost.dart';
import 'package:post/models/user.dart';
import 'package:post/services/api.services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeaderSection();
  }
}

class HeaderSection extends State<UserProfilePage> {
  final Color green = Color(0xFF1E8161);

  String token = '';
  User user;
  Map<String, dynamic> realUser;
  List<FullPost> posts = new List<FullPost>();
  //var postCnt = posts.length;

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    Map<String, dynamic> jsonObject = json.decode(prefs.getString('user'));
    User extractedUser = new User();
    extractedUser = User.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
      //postCount = postCnt;
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    this.getUserData();
    this.getPostData();
  }

  Future<String> getUserData() async {
    var response = await APIServices.getUser(user.id);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      realUser = convertDataToJson;
    });

    return "Success";
  }

  Future<String> getPostData() async {
    var response = await APIServices.getPostsForUser(user.id);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      posts = convertDataToJson;
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        elevation: 0,
        backgroundColor: green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {}, //dodati
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {}, //edit profile
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 3, bottom: 16),
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Column(
                children: <Widget>[
                  Icon(Icons.account_circle, color: Colors.white, size: 110),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      realUser["username"],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      realUser["firstName"] + " " + realUser["lastName"],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 16, top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                //postCount,
                                "17",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 16),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.image,
                                      color: Colors.white, size: 36),
                                  Text(
                                    'Objave',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "77",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 16),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.check,
                                      color: Colors.white, size: 36),
                                  Text(
                                    'Poeni',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "7",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 16),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.star_border,
                                      color: Colors.white, size: 36),
                                  Text(
                                    'Nivo',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Expanded(
              child: new ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return PostItem(
                      post: posts[index],
                    );
                  }),
            )
          ]),
        ],
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final dynamic post;

  const PostItem({
    this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "lokacija",
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              child: Image.asset(
                post["photoPath"],
                height: 150,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post["description"],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
