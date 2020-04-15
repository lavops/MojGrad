import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/filters.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/NavDrawer.dart';
import 'package:frontend/widgets/postWidget.dart';

class FeedPage extends StatefulWidget {
  final User user;
  FeedPage(this.user);
  @override
  _FeedPageState createState() => _FeedPageState(user);
}

class _FeedPageState extends State<FeedPage> {
  User user;
  List<FullPost> listPosts;

  _FeedPageState(User user1) {
    this.user = user1;
  }

  _getPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPost(jwt).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPosts = listP;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[50],
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black87,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: Text(
            "MOJ GRAD",
            style: TextStyle(
              color: Colors.green[800],
              fontSize: 22.0,
              fontStyle: FontStyle.normal,
              fontFamily: 'pirulen rg',
            ),
          ),
          actions: <Widget>[
            SizedBox(width: 16.0),
            PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(Icons.filter_list, color: Colors.black),
                itemBuilder: (BuildContext context) {
                  return Filteri.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
            Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              _getPosts();
            },
            child: (listPosts != null)
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 30.0),
                    itemCount: listPosts == null ? 0 : listPosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostWidget(listPosts[index]);
                    })
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                    ),
                  )));
  }
}

void choiceAction(String choice) {
  if (choice == Filteri.kategorije) {
    print('Kategorije');
  } else if (choice == Filteri.gradovi) {
    print('Gradovi');
  } else if (choice == Filteri.brojlajkova) {
    print('Broj lajkova');
  } else if (choice == Filteri.vreme) {
    print('Vreme');
  }
}
