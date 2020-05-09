import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionDesktop.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

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
  
  showAlertDialog(BuildContext context, int id, int index, int page) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Obriši",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        APIServices.deleteInstitution(TokenSession.getToken, id);
        setState(() {
          if(page == 1){
            listInstitutions.removeAt(index);
          }
          else if(page == 2){
            listUnauthInstitutions.removeAt(index);
          }
        });
        Navigator.pop(context);
      },
    );
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: greenPastel),
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

  showAlertDialogAccept(BuildContext context, int id, String email, int index, int page) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Prihvati",
        style: TextStyle(color: greenPastel),
      ),
      onPressed: () {
        APIServices.acceptInstitution(TokenSession.getToken, id, email).then((res){
          if(res.statusCode == 200){
            setState(() {
              listInstitutions.insert(0, listUnauthInstitutions[index]);
              listUnauthInstitutions.removeAt(index);
            });
          }
        });
        Navigator.pop(context);
      },
    ).showCursorOnHover;
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ).showCursorOnHover;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Prihvati zahtev"),
      content: Text("Da li ste sigurni da želite da prihvatite zahtev?"),
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
            Text("Kontakt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            Row(
              children: <Widget>[
                Text("Broj telefona: ", style: TextStyle(fontSize: 10)),
                Text(phone,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      fontSize: 10
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Text("E-mail: ", style: TextStyle(fontSize: 10)),
                Text(email,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      fontSize: 10
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
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(listInst[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
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
                                choiceActionAllInstitutions(choice,listInst[index].id, listInst[index].description, index);
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

  void choiceActionAllInstitutions(String choice, int institutionId, String description, int index) {
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
                  style: TextStyle(color: greenPastel),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsAllInstitutions.ObrisiInstitutciju) {
      print("Brisanje institucije.");
      showAlertDialog(context, institutionId, index, 1);
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
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(listInst[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
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
                                choiceActionRequestsInstitutions(choice,listInst[index].id, listInst[index].description, listInst[index].email, index);
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

  void choiceActionRequestsInstitutions(String choice, int institutionId, String description, String email, int index) {
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
                  style: TextStyle(color: greenPastel),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsRequestsInstitutions.ObrisiInstitutciju) {
      print("Brisanje institucije.");
      showAlertDialog(context, institutionId, index, 2);
    } else if (choice == ConstantsRequestsInstitutions.PrihvatiInstitutciju) {
      print("Prihvati instituciju.");
      showAlertDialogAccept(context, institutionId,email, index, 2);
    }
  }

  Widget search() {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: 300,
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: Colors.black,
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
            prefixIcon: Icon(Icons.search, color: greenPastel),
            hintText: 'Pretraži...',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(width: 2, color: greenPastel),
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
          cursorColor: Colors.black,
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
            prefixIcon: Icon(Icons.search, color: greenPastel),
            hintText: 'Pretraži...',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(width: 2, color: greenPastel),
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
