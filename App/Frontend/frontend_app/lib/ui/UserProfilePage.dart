import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/bloc/themes.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/login.dart';
import 'package:frontend/widgets/postWidget.dart';
import 'package:frontend/widgets/userInfoWidget.dart';
import '../main.dart';
import 'EditProfilePage.dart';
import 'package:provider/provider.dart';

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

  final Color green = Colors.green[800];
  List<FullPost> posts;
  bool darkThemeEnabled = MyApp.ind == 0 ? false : true;

  _getPosts() async {
     var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostsForUser(jwt, user.id).then((res) {
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
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white
      ),
      endDrawer: Drawer(
        child : Container(
         //color : Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              /*decoration: BoxDecoration(
                color: Colors.white
              ),*/
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
                style: TextStyle(fontSize: 16, color: Colors.black),
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
              title: Text("Tamna tema", style: TextStyle(fontSize: 16, color: Colors.black)),
              trailing: Switch(
                value: darkThemeEnabled,
                onChanged: (changedTheme) {
                  setState(() {
                    darkThemeEnabled = changedTheme;
                    MyApp.ind = changedTheme ? 1 : 0;
                  });
                  changedTheme ? _themeChanger.setTheme(ThemeData.dark()) : _themeChanger.setTheme(ThemeData.light());
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black),
              title: Text(
                'Odjavi se',
                style: TextStyle(fontSize: 16, color: Colors.black),
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
        )
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
            ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: posts == null ? 0 : posts.length,
              itemBuilder: (BuildContext context, int index) {
                return PostWidget(posts[index]);
              }
            ):
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
