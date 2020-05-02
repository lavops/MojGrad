import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/singlePostIWidget.dart';

class HomeInstitutionDesktop extends StatefulWidget {
  @override
  _HomeInstitutionDesktopState createState() => _HomeInstitutionDesktopState();
}

class _HomeInstitutionDesktopState extends State<HomeInstitutionDesktop> {
  
  List<FullPost> listUnsolvedPosts;

  _getAllPosts() async {
    APIServices.getPost(TokenSession.getToken).then((res) {
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

  @override
  void initState() {
    super.initState();
    _getAllPosts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
    CenteredViewPost(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 30.0),
        itemCount: listUnsolvedPosts == null ? 0 : listUnsolvedPosts.length,
        itemBuilder: (BuildContext context, int index) {
          return SinglePostIWidget(listUnsolvedPosts[index]);
        }
      ),
    ),
    CollapsingInsNavigationDrawer()
    ]);
  }
}
/*
class HomePage2 extends StatefulWidget {
  HomePage2(this.jwt, this.payload);
  factory HomePage2.fromBase64(String jwt) => HomePage2(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomePage2State createState() => new _HomePage2State(jwt, payload);
}

class _HomePage2State extends State<HomePage2> {

  Institution institution;
  List<FullPost> listUnsolvedPosts;

  final String jwt;
  final Map<String, dynamic> payload;

  _HomePage2State(this.jwt, this.payload);


  _getInstitutionId() {
    int inId = int.parse(payload['sub']);
    setState(() {
      insId = inId;
    });
  }

  _getInstitutionWithId(int id) async {
      var res = await APIServices.getInstitutionById(TokenSession.getToken, id);
      Map<String, dynamic> jsonInst = jsonDecode(res.body);
      Institution inst = Institution.fromObject(jsonInst);
      setState(() {
        institution = inst;
        icityId = institution.cityId;
      });
    }

  _getUnsolved(int cityId)  async {
    APIServices.getInstitutionUnsolvedFromCityId(TokenSession.getToken, cityId).then((res) {
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



  @override
  void initState() {
    super.initState();
    _getInstitutionId();
    _getInstitutionWithId(insId);
    _getUnsolved(icityId);
  }



  @override
  Widget build(BuildContext context) {
    double width1 = MediaQuery.of(context).size.width -300; //> 400 ? MediaQuery.of(context).size.width - 300 : MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Institucija " + institution.name),
      ),
      //drawer: NavDrawer(),
      body: Row(
        children: <Widget>[
          CollapsingInsNavigationDrawer(),
          Center(
            child: Container(
                width: width1,
                padding: EdgeInsets.all(10.0),
                child: (listUnsolvedPosts != null)
                        ? PostWidget(listUnsolvedPosts)
                        : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                      ),
                    )
            ),
          ),
        ],
      ),
    );
  }





}
*/