import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/postType.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostDesktop.dart';

List<int> listSelectedTypes = new List();
 

class HomeInstitutionDesktop extends StatefulWidget {

 final int id;
 HomeInstitutionDesktop({Key key, this.id});

  @override
  _HomeInstitutionDesktopState createState() => _HomeInstitutionDesktopState();
}

class _HomeInstitutionDesktopState extends State<HomeInstitutionDesktop> {
  
  List<FullPost> listUnsolvedPosts;
  Institution institution;
  List<PostType> listTypes;
  List<FullPost> listFilteredPosts;

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

  _getFiltered() async {
    
    if(listSelectedTypes!= null && listSelectedTypes.length != 0){
    await APIServices.getFiltered(TokenSession.getToken, listSelectedTypes, icityId).then((res) {
    Iterable list = json.decode(res.body);
        List<FullPost> posts = new List<FullPost>();
    posts = list.map((model) => FullPost.fromObject(model)).toList();
    print("Vratilaa: "+res.body);
    setState(() {
      listFilteredPosts = posts;
      listUnsolvedPosts = null;
       });
    });
    }
    else
    {
      await APIServices.getInstitutionUnsolvedFromCityId(TokenSession.getToken,icityId).then((res) {
    Iterable list = json.decode(res.body);
        List<FullPost> posts = new List<FullPost>();
    posts = list.map((model) => FullPost.fromObject(model)).toList();
    setState(() {
      listFilteredPosts = posts;
      listUnsolvedPosts = null;
       });
    });
    }

  }




  @override
  void initState() {
    super.initState();
    _getUnsolvedPosts();
    _getPostType();
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
  Widget build(BuildContext context) {
    print(listSelectedTypes.toString());
    print("Filtered lista" + listFilteredPosts.toString());
    if(listFilteredPosts!= null) print( listFilteredPosts[0].username);
    return Stack(children: <Widget>[
    CenteredViewPost(
      child:  ListView.builder(
          padding: EdgeInsets.only(bottom: 30.0),
          itemCount: listFilteredPosts == null ? 0 :  listFilteredPosts.length,
          itemBuilder: (BuildContext context, int index) {
           
             return Container(child:  Text(index.toString()+": "+listFilteredPosts[index].username),);
           
          }
      ),
    ),
    CollapsingInsNavigationDrawer(),
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
            setState(() {
               _getFiltered();
            });
           
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
              }
              else {
                List<int> lista = new List();
                for (int i = 0; i < listSelectedTypes.length; i++) {
                  if (listSelectedTypes[i] != widget.id) {
                    lista.add(listSelectedTypes[i]);
                  }
                }
                listSelectedTypes = lista;
              }

            });
          }),
    );
  }
}
