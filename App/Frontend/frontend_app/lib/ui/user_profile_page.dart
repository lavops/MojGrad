import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/login.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:frontend/widgets/postWidget.dart';
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
    print("korisnik ${user1.id}");
  }

  final Color green = Color(0xFF1E8161);
  List<FullPost> posts;

  _getPosts() {
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

  _removeToken() async {
    storage.delete(key: "jwt");
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
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
            onPressed: () {
              String jwt;
              APIServices.jwtOrEmpty().then((res) {
                setState(() {
                  jwt = res;
                });
                if (res != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage.fromBase64(res)));
                }
              });
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
              onTap: () {
                _removeToken();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 3, bottom: 16),
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    CircleImage(
                      serverURLPhoto + user.photo,
                      imageSize: 90.0,
                      whiteMargin: 2.0,
                      imageMargin: 20.0,
                    ),
                    Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 70),
                              child: Text(
                                user.username,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 70),
                              child: Text(
                                user.firstName + " " + user.lastName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ),
                          ]),
                    ),
                  ]),
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
                                user.postsNum.toString(),
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
                                user.points.toString(),
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
                                user.level.toString(),
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
                child: (posts != null)
                    ? PostWidget(posts)
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.green[800]),
                        ),
                      ))
          ]),
        ],
      ),
    );
  }
}
