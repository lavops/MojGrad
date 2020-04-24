import 'package:flutter/material.dart';
import 'package:frontend/models/like.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'dart:convert';

class LikesPage extends StatefulWidget {
  final int postId;
  LikesPage(this.postId);

  @override
  State<StatefulWidget> createState() {
    return StateLikes(postId);
  }
}

class StateLikes extends State<LikesPage> {
  int postId;
  StateLikes(int id) {
    postId = id;
  }
  List<Like> listLikes;
  List<Like> listDislikes;

  _getLikeInPost() async {
     var jwt = await APIServices.jwtOrEmpty();
    APIServices.likeInPost(jwt, postId).then((res) {
      //umesto 1 stavlja se idPosta
      Iterable list = json.decode(res.body);
      List<Like> listLike = List<Like>();
      listLike = list.map((model) => Like.fromObject(model)).toList();
      setState(() {
        listLikes = listLike;
      });
    });
  }

  _getDislikeInPost() async {
     var jwt = await APIServices.jwtOrEmpty();
    APIServices.dislikeInPost(jwt, postId).then((res) {
      //umesto 1 stavlja se idPosta
      Iterable list = json.decode(res.body);
      List<Like> listDislike = List<Like>();
      listDislike = list.map((model) => Like.fromObject(model)).toList();
      setState(() {
        listDislikes = listDislike;
      });
    });
  }

  void initState() {
    super.initState();
    _getLikeInPost();
    _getDislikeInPost();
  }

  Widget buildLikeList() {
    return ListView.builder(
      itemCount: listLikes == null ? 0 : listLikes.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(children: [
                    CircleImage(
                      serverURLPhoto + listLikes[index].photo,
                      imageSize: 56.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 260,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listLikes[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              listLikes[index].firstName +
                                  " " +
                                  listLikes[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15))
                        ],
                      ),
                    ),
                  ])),
            ],
          ),
        ));
      },
    );
  }

  Widget buildDislikeList() {
    return ListView.builder(
      itemCount: listDislikes == null ? 0 : listDislikes.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(children: [
                    CircleImage(
                      serverURLPhoto + listDislikes[index].photo,
                      imageSize: 56.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 260,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listDislikes[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              listDislikes[index].firstName +
                                  " " +
                                  listDislikes[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15))
                        ],
                      ),
                    ),
                  ])),
            ],
          ),
        ));
      },
    );
  }

  Widget tabs() {
    return TabBar(
        labelColor: Colors.green[800],
        indicatorColor: Colors.green[800],
        unselectedLabelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            child: Text("Sviđanja"),
          ),
          Tab(
            child: Text("Nesviđanja"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
              title: Text('Reakcije', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
              backgroundColor: Theme.of(context).copyWith().backgroundColor,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    String jwt;
                    APIServices.jwtOrEmpty().then((res) {
                      setState(() {
                        jwt = res;
                      });
                      if (res != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage.fromBase64(jwt.toString())),
                        );
                      }
                    });
                  }),
              bottom: tabs(),
            ),
            body: TabBarView(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(child: buildLikeList()),
                  ])),
              Container(
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(child: buildDislikeList()),
                  ])),
            ])));
  }
}
