import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/login.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:frontend/widgets/postWidget.dart';
import 'package:frontend/widgets/userInfoWidget.dart';
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
  ScrollController _scrollController;
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
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[50],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: Center(child: Text(
                user.firstName + " " + user.lastName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),)
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
      body: (user != null)?NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              // User information section
              SliverToBoxAdapter(child: UserInfoWidget(user)),
            ];
          },
          body: (posts != null)?
            PostWidget(posts):
            Center(child: CircularProgressIndicator(
              valueColor:new AlwaysStoppedAnimation<Color>(Colors.green[800]),
              ),
            )
        ):Center(child: CircularProgressIndicator(
          valueColor:new AlwaysStoppedAnimation<Color>(Colors.green[800]),
          ),
        ),
    );
  }
}
