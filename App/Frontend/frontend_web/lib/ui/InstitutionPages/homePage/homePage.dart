import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/postWidget.dart';

int insId;
int icityId;

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
                child: RefreshIndicator(
                    child: (listUnsolvedPosts != null)
                        ? PostWidget(listUnsolvedPosts)
                        : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                      ),
                    )
                )
            ),
          ),
        ],
      ),
    );
  }





}
