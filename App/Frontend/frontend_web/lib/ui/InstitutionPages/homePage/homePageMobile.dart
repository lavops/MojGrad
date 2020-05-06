import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostMobile.dart';

class HomeInstitutionMobile extends StatefulWidget {
  @override
  _HomeInstitutionMobileState createState() => _HomeInstitutionMobileState();
}

class _HomeInstitutionMobileState extends State<HomeInstitutionMobile> {
  List<FullPost> listUnsolvedPosts;
  Institution institution;

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

  @override
  void initState() {
    super.initState();
    _getUnsolvedPosts();
  }
  
  @override
  Widget build(BuildContext context) {
    return CenteredViewPost(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 30.0),
        itemCount: listUnsolvedPosts == null ? 0 : listUnsolvedPosts.length,
        itemBuilder: (BuildContext context, int index) {
          return InsRowPostMobileWidget(listUnsolvedPosts[index]);
        }
      ),
    );
  }
}