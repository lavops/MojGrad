import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';

class ManageInstitutionMobile extends StatefulWidget {
  @override
  _ManageInstitutionMobileState createState() => _ManageInstitutionMobileState();
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

class _ManageInstitutionMobileState extends State<ManageInstitutionMobile> with SingleTickerProviderStateMixin{
  List<Institution> listInstitutions;
  List<Institution> listUnauthInstitutions;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<Institution> filteredInstitution;
  List<Institution> filteredUnauthInstitution;

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
          MaterialPageRoute(builder: (context) => ManageInstitutionPage()),
        );
      },
    );
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.pop(context);
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
                            Expanded(child: SizedBox()),
                            contactWidget(listInst[index].phone, listInst[index].email),
                            Expanded(child: SizedBox()),
                            PopupMenuButton<String>(
                              onSelected: (String choice) {
                                choiceActionAllInstitutions(choice,listInst[index].id, listInst[index].description );
                              },
                              itemBuilder: (BuildContext context) {
                                return ConstantsAllInstitutions.choices.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          ])
                    ],
                  ))),
            ],
          ),
        ));
      },
    );
  }

  void choiceActionAllInstitutions(String choice, int institutionId, String description) {
    if (choice == ConstantsAllInstitutions.OpisInstitucije) {
      print("Opis institucije.");
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Opis institucije", style: TextStyle(color: Colors.black),),
            content: Container(
              height: 300,
              child: descriptionWidget(description),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izadji",
                  style: TextStyle(color: Colors.green[800]),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsAllInstitutions.ObrisiInstitutciju) {
      print("Brisanje institucije.");
      showAlertDialog(context, institutionId);
    }
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
                            Expanded(child: SizedBox()),
                            contactWidget(listInst[index].phone, listInst[index].email),
                            Expanded(child: SizedBox()),
                            PopupMenuButton<String>(
                              onSelected: (String choice) {
                                choiceActionRequestsInstitutions(choice,listInst[index].id, listInst[index].description, listInst[index].email);
                              },
                              itemBuilder: (BuildContext context) {
                                return ConstantsRequestsInstitutions.choices.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          ])
                    ],
                  ))),
            ],
          ),
        ));
      },
    );
  }

  void choiceActionRequestsInstitutions(String choice, int institutionId, String description, String email) {
    if (choice == ConstantsRequestsInstitutions.OpisInstitucije) {
      print("Opis institucije.");
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Opis institucije", style: TextStyle(color: Colors.black),),
            content: Container(
              height: 300,
              child: descriptionWidget(description),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izadji",
                  style: TextStyle(color: Colors.green[800]),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsRequestsInstitutions.ObrisiInstitutciju) {
      print("Brisanje institucije.");
      showAlertDialog(context, institutionId);
    } else if (choice == ConstantsRequestsInstitutions.PrihvatiInstitutciju) {
      print("Prihvati instituciju.");
      APIServices.acceptInstitution(TokenSession.getToken, institutionId, email);
      setState(() {
        _getUnauthInstitutions();
        _getUnauthInstitutions();
        _getUnauthInstitutions();
      });
      _getUnauthInstitutions();
    }
  }

  Widget search() {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: 300,
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
        width: 300,
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

  @override
  Widget build(BuildContext context) {
    return CenteredViewManageUser(
          child: TabBarView(children: <Widget>[
          Column(children: [
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
              ]),
          Column(children: [
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
              ]),
        ]),
        );
  }
}
