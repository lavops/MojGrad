import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile_page.dart';
import 'homePage.dart';

class UserProfilePage extends StatefulWidget {
  final User user;

  UserProfilePage(this.user);

  @override
  State<StatefulWidget> createState() {
    return HeaderSection(user);
  }
}

class HeaderSection extends State<UserProfilePage> {
  User user;
  HeaderSection(User user1) {
    user = user1;
  }

  final Color green = Color(0xFF1E8161);
  //Map<String, dynamic> realUser;
  List<FullPost> posts;

  //var postCnt = posts.length;
  /*
  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    Map<String, dynamic> jsonObject = json.decode(prefs.getString('user'));
    User extractedUser = new User();
    extractedUser = User.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
      
    });
  }
  */
  getPosts() {
    APIServices.getPostsForUser(user.id).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          posts = listP;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getPosts();
    return new Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        elevation: 0,
        backgroundColor: green,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBottomBar()));
            }),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: green,
              ),
              child: Text(
                user.firstName + " " + user.lastName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.black),
              trailing: Icon(Icons.arrow_right, color: Colors.black),
              title: Text(
                'Izmeni profil',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black),
              //trailing: Icon(Icons.arrow_right, color: Colors.black),
              title: Text(
                'Odjavi se',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {},
            ),
            /*Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          ListTile(
                              leading: Icon(Icons.settings),
                              title: Text('Podešavanja')),
                          ListTile(
                              leading: Icon(Icons.help),
                              title: Text('Pomoć i feedback'))
                        ],
                      ),
                    ))),*/
          ],
        ),
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
                      user.username,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      user.firstName + " " + user.lastName,
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
                  itemCount: posts == null ? 0 : posts.length,
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
  final FullPost post;

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
                "assets/post1.jpg",
                width: 300,
                height: 250,
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
                          post.description,
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
