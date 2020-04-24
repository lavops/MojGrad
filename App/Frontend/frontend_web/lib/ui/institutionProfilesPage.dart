import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'dart:convert';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class InstitutionProfilesPage extends StatefulWidget {
  @override
  _InstitutionProfilesPageState createState() =>
      new _InstitutionProfilesPageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _InstitutionProfilesPageState extends State<InstitutionProfilesPage> {
  List<Institution> listInstitutions;
  List<Institution> listUnauthInstitutions;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<Institution> filteredInstitution;
  List<Institution> filteredUnauthInstitution;

  
  _email() async {
  String username = "mojgrad.info@gmail.com";
  String password = "MojGrad22";

  final smtpServer = gmail(username, password); 
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add('anan87412@gmail.com') //recipent email 
    ..subject = 'Test ' //subject of the email
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'; //body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print('Message not sent. \n'+ e.toString()); //print if the email is not sent
    // e.toString() will show why the email is not sending
  }
  } 

  _getInstitutions() {
    APIServices.getAllAuthInstitutions(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Institution> listU = List<Institution>();
      listU = list.map((model) => Institution.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listInstitutions = listU;
        });
      }
    });
  }

  _getUnauthInstitutions() {
    APIServices.getAllUnauthInstitutions(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Institution> listU = List<Institution>();
      listU = list.map((model) => Institution.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnauthInstitutions = listU;
        });
      }
    });
  }

  void initState() {
    super.initState();
    _getInstitutions();
    _getUnauthInstitutions();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Obriši",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        APIServices.deleteInstitution(TokenSession.getToken, id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstitutionProfilesPage()),
        );
      },
    );
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstitutionProfilesPage()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje institucije"),
      content: Text("Da li ste sigurni da želite da obrišete instituciju?"),
      actions: [
        okButton,
        notButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget contactWidget(String phone, String email) => Container(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kontakt", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: <Widget>[
                Text("Broj telefona: ", style: TextStyle(fontSize: 15)),
                Text(phone,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Text("E-mail: ", style: TextStyle(fontSize: 15)),
                Text(email,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    )),
              ],
            ),
          ],
        ),
      );

  Widget descriptionWidget(String description) => Container(
        width: 400,
        padding: EdgeInsets.all(10),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Opis", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(description, style: TextStyle(fontSize: 14)),
          ],
        ),
      );

  Widget buildInstList(List<Institution> listInst) {
    return ListView.builder(
      itemCount: listInst == null ? 0 : listInst.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(listInst[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleImage(
                              userPhotoURL + listInst[index].photoPath,
                              imageSize: 56.0,
                              whiteMargin: 2.0,
                              imageMargin: 6.0,
                            ),
                            contactWidget(
                                listInst[index].phone, listInst[index].email),
                            descriptionWidget(listInst[index].description),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(11.0),
                                  side: BorderSide(color: Colors.redAccent)),
                              color: Colors.redAccent,
                              child: Text(
                                "Obriši instituciju",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                showAlertDialog(context, listInst[index].id);
                              },
                            )
                          ])
                    ],
                  ))),
            ],
          ),
        ));
      },
    );
  }

  Widget buildUnauthInstList(List<Institution> listInst) {
    return ListView.builder(
      itemCount: listInst == null ? 0 : listInst.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(listInst[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleImage(
                              userPhotoURL + listInst[index].photoPath,
                              imageSize: 56.0,
                              whiteMargin: 2.0,
                              imageMargin: 6.0,
                            ),
                            contactWidget(
                                listInst[index].phone, listInst[index].email),
                            descriptionWidget(listInst[index].description),
                            Row(children: <Widget>[
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(11.0),
                                  side: BorderSide(color: Colors.redAccent)),
                              color: Colors.redAccent,
                              child: Text(
                                "Obriši instituciju",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                showAlertDialog(context, listInst[index].id);
                              },
                            ),
                            SizedBox(width: 10,),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(11.0),
                                  side: BorderSide(color: Colors.green[800])),
                              color: Colors.green[800],
                              child: Text(
                                "Prihvati zahtev",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _email();
                               // APIServices.acceptInstitution(TokenSession.getToken, listInst[index].id);
                               // _getUnauthInstitutions();
                              },
                            )
                            ],),
                          ])
                    ],
                  ))),
            ],
          ),
        ));
      },
    );
  }

  Widget search() {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: 550,
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (string) {
            _debouncer.run(() {
              setState(() {
                filteredInstitution = listInstitutions
                    .where((u) => (u.name.contains(string)))
                    .toList();
              });
            });
          },
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.green[800]),
            hintText: 'Pretraži...',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(width: 2, color: Colors.green[800]),
            ),
          ),
          controller: searchController,
        ));
  }

  Widget searchUnath() {
    return Container(
        margin: EdgeInsets.only( top: 5, bottom: 5),
        width: 550,
        padding: const EdgeInsets.all(8.0),
        child:TextField(
          onChanged: (string) {
            _debouncer.run(() {
              setState(() {
                filteredUnauthInstitution = listUnauthInstitutions
                    .where((u) => (u.name.contains(string)))
                    .toList();
              });
            });
          },
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.green[800]),
            hintText: 'Pretraži...',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(width: 2, color: Colors.green[800]),
            ),
          ),
          controller: searchRepController,
        ));
  }

  Widget tabs() {
    return TabBar(
        //onTap
        labelColor: Colors.green,
        indicatorColor: Colors.green,
        unselectedLabelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            child: Text("Sve institucije"),
          ),
          Tab(
            child: Text("Zahtevi za registraciju"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Upravljanje institucijama',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManagementPage()));
              }),
          bottom: tabs(),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 80, right: 80),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        search(),
                      ],
                    ),
                    Flexible(
                        child: filteredInstitution == null
                            ? buildInstList(listInstitutions)
                            : buildInstList(filteredInstitution)),
                  ])),
              Container(
                  margin: EdgeInsets.only(left: 80, right: 80),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        searchUnath(),
                      ],
                    ),
                    Flexible(
                        child: filteredUnauthInstitution == null
                            ? buildUnauthInstList(listUnauthInstitutions)
                            : buildUnauthInstList(filteredUnauthInstitution)),
                  ])),
            ]),
            CollapsingNavigationDrawer(),
          ],
        ),
      ),
    );
  }
}
