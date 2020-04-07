import 'package:flutter/material.dart';
import 'package:frontend_web/ui/usersProfilePage.dart';
import 'package:frontend_web/models/report.dart';
import 'package:frontend_web/services/api.services.dart';
import 'dart:convert';
import 'package:frontend_web/widgets/circleImageWidget.dart';


class ReportedUserDetailsPage extends StatefulWidget {
  final int id;
  final String firstName;
  final String lastName;

  ReportedUserDetailsPage({Key key, this.id, this.firstName, this.lastName});

  @override
  _ReportedUserDetailsPage createState() => _ReportedUserDetailsPage();
}

class _ReportedUserDetailsPage extends State<ReportedUserDetailsPage> {
  List<Report> listReports;

  _getReportedUser(int id) {
    APIServices.getReportedUser(id).then((res) {
      Iterable list = json.decode(res.body);
      List<Report> listR = List<Report>();
      listR = list.map((model) => Report.fromObject(model)).toList();
      if (mounted) {
        setState( () {
          listReports = listR;
        });
      }
    });
  }

  Widget buildReportsList() {
    _getReportedUser(widget.id);
    return ListView.builder(
      itemCount: listReports == null ? 0 : listReports.length,
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
                          userPhotoURL + listReports[index].photo,
                          imageSize: 56.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                          width: 180,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listReports[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  listReports[index].firstName +
                                      " " +
                                      listReports[index].lastName,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic, fontSize: 15))
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(width: 20),
                       
                            Text(
                              'Datum prijave',
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            ),
							Text(
                              listReports[index].time.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
							
                          ],
                        ),
                        SizedBox(width: 90),
                        Column(
                          children: <Widget>[

                            Text(
                              'Razlog prijave',
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            ),
							
							Text(
                              listReports[index].reportTypeName,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ])),
                ],
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title:Text("Detalji o prijavi korisnika ${widget.firstName} ${widget.lastName}",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UsersProfilePage()));
            }),
      ),
      body: Container(
          margin: EdgeInsets.only(left:350, right: 350),
          padding: EdgeInsets.only(top: 0),
          color: Colors.green,
          child: Column(children: [
            Flexible(child: buildReportsList()),
          ])),
    );
  }
}