import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/postWidget.dart';
import 'package:frontend/widgets/userInfoWidget.dart';
import 'edit_profile_page.dart';

class OthersProfilePage extends StatefulWidget {
  final int otherUserId;

  OthersProfilePage(this.otherUserId);

  @override
  State<StatefulWidget> createState() {
    return HeaderSection(otherUserId);
  }
}

class HeaderSection extends State<OthersProfilePage> {
  ScrollController _scrollController;
  int otherUserId;
  User otherUser;
  HeaderSection(int otherUserId1) {
    otherUserId = otherUserId1;
    print("korisnik $otherUserId1");
  }

  final Color green = Color(0xFF1E8161);
  List<FullPost> posts;

  _getUser() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getUser(jwt, otherUserId).then((res) {
      Map<String, dynamic> jsonUser = jsonDecode(res.body);
      User otherUser1 = User.fromObject(jsonUser);
      setState(() {
        otherUser = otherUser1;
      });
    });
  }

  _getPosts() async {
     var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostsForUser(jwt, otherUserId).then((res) {
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
  void initState() {
    super.initState();
    _getUser();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[50],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              APIServices.jwtOrEmpty().then((res) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage.fromBase64(res.toString())),
                );
              });
            }),
      ),
      body: (otherUser != null)?NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              // User information section
              SliverToBoxAdapter(child: UserInfoWidget(otherUser)),
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
