import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/postType.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostMobile.dart';

List<int> listSelectedTypes = new List();


class HomeInstitutionMobile extends StatefulWidget {
  @override
  _HomeInstitutionMobileState createState() => _HomeInstitutionMobileState();
}

class _HomeInstitutionMobileState extends State<HomeInstitutionMobile> {
  List<FullPost> listUnsolvedPosts;
  Institution institution;
  List<FullPost> listFilteredPosts;
  List<PostType> listTypes;

  _getUnsolvedPosts() async  {

    var res = await APIServices.getInstitutionById(TokenSession.getToken, insId);
    Map<String, dynamic> jsonInst = jsonDecode(res.body);
    Institution inst = Institution.fromObject(jsonInst);
    setState(() {
      institution = inst;
      icityId = institution.cityId;
    });

    res =  await APIServices.getInstitutionUnsolvedFromCityId(TokenSession.getToken, icityId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnsolvedPosts = listP;
        });
      }
    });
  }

  _getFiltered() async {
    var res = await APIServices.getFiltered(TokenSession.getToken, listSelectedTypes);
    Iterable list = json.decode(res.body);
    List<FullPost> posts = new List<FullPost>();
    posts = list.map((model) => FullPost.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listFilteredPosts = new List();
        listFilteredPosts = posts;
        listUnsolvedPosts = null;
      });
    }
  }

  _getPostType() async {
    var res =  await APIServices.getPostType(TokenSession.getToken);
    Iterable list = json.decode(res.body);
    List<PostType> postTypes = new List<PostType>();
    postTypes = list.map((model) => PostType.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listTypes = postTypes;
      });
    }
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: listTypes == null ? 0 : listTypes.length,
        itemBuilder: (BuildContext context, int index) {
          return Box(
            title: listTypes[index].typeName,
            id: listTypes[index].id,
          );
        }
    );
  }





  @override
  void initState() {
    super.initState();
    _getUnsolvedPosts();
    _getPostType();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CenteredViewPost(
        child: listUnsolvedPosts != null ?
        ListView.builder(
            padding: EdgeInsets.only(bottom: 30.0),
            itemCount: listUnsolvedPosts == null ? 0 : listUnsolvedPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return InsRowPostMobileWidget(listUnsolvedPosts[index], 1);
            }
        ) : ListView.builder(
            padding: EdgeInsets.only(bottom: 30.0),
            itemCount: listFilteredPosts == null ? 0 : listFilteredPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return InsRowPostMobileWidget(listFilteredPosts[index], 1);
            }
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 300, top: 50),
        width: 500,
        child: listTypes != null ?
        buildList()
            : Text('Neki tekst'),
      ),
      Container(
        padding: EdgeInsets.only(left: 250, top: 10),
        child: FlatButton(
          child: Text('Primeni'),
          onPressed: () {
            _getFiltered();
          },
        ),
      )
    ]);
  }
}








class Box extends StatefulWidget {
  final String title;
  final int id;

  Box({this.title, this.id});

  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Checkbox(
          value: selected,
          onChanged: (bool val) {
            setState(() {
              selected = val;
              if (selected == true) {
                listSelectedTypes.add(widget.id);
                print(listSelectedTypes);
              }
              else {
                List<int> lista = new List();
                for (int i = 0; i < listSelectedTypes.length; i++) {
                  if (listSelectedTypes[i] != widget.id) {
                    lista.add(listSelectedTypes[i]);
                  }
                }
                listSelectedTypes = lista;
                print(listSelectedTypes);
              }

            });
          }),
    );
  }
}
