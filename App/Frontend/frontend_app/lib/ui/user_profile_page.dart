import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/login.dart';
import 'package:frontend/widgets/postWidget.dart';
import 'package:frontend/widgets/userInfoWidget.dart';
import 'edit_profile_page.dart';
import 'globalValues.dart';

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
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Globals.switchStatus == true ? Globals.colorWhite : Globals.colorBlack),
        backgroundColor: Globals.theme,
      ),
      endDrawer: Drawer(
        child : Container(
         color : Globals.theme,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Globals.switchStatus == true ? Globals.themeBck : Globals.colorWhite
              ),
              child: Center(child: Text(
                user.firstName + " " + user.lastName,
                style: TextStyle(
                    color: Globals.switchStatus == true ? Globals.colorWhite : Globals.colorBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),)
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Globals.switchStatus == true ? Globals.colorWhite70 : Globals.colorBlack),
              trailing: Icon(Icons.arrow_right, color: Globals.switchStatus == true ? Globals.colorWhite70 : Globals.colorBlack),
              title: Text(
                'Izmeni profil',
                style: TextStyle(fontSize: 16, color: Globals.switchStatus == true ? Globals.colorWhite70 : Globals.colorBlack),
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
              title: Text("Tamna tema", style: TextStyle(fontSize: 16, color: Globals.switchStatus == true ? Globals.colorWhite70 : Globals.colorBlack),),
              trailing: Switch(
                value: Globals.switchStatus,
                onChanged: (value) {
                  setState(() {
                  
                    if(Globals.switchStatus == true) { 
                      Globals.theme = Colors.white;
                      Globals.colorBlack = Colors.black;
                      Globals.switchStatus = false;
                    }
                    else {
                      Globals.theme =  Colors.black87;
                      Globals.colorWhite = Colors.white;
                      Globals.themeBck =  Colors.black38;
                      Globals.colorBlack = Colors.black;
                      Globals.colorBlack12 = Colors.black12;
                      Globals.green =  Color(0xFF1E8161);
                      Globals.switchStatus = true;
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Globals.switchStatus == true ? Globals.colorWhite70 : Globals.colorBlack),
              title: Text(
                'Odjavi se',
                style: TextStyle(fontSize: 16, color: Globals.switchStatus == true ? Globals.colorWhite70 : Globals.colorBlack),
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
