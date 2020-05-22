import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

import 'manageInstitutionMobile.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageInstitutionDesktop extends StatefulWidget {
  @override
  _ManageInstitutionDesktopState createState() =>
      _ManageInstitutionDesktopState();
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

class _ManageInstitutionDesktopState extends State<ManageInstitutionDesktop>
    with SingleTickerProviderStateMixin {
  List<Institution> listInstitutions;
  List<Institution> listUnauthInstitutions;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<Institution> filteredInstitution;
  List<Institution> filteredUnauthInstitution;
  List<Institution> listInstitutionsFilt;

  List<City> listCities;
  City city;
  City cityU;
  List<MaxMinDropDown> maxMinFilter = MaxMinDropDown.getMaxMinDropDown();
  MaxMinDropDown maxMinF;

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

  _getCities() {
    APIServices.getCity(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<City> listC = List<City>();
      listC = list.map((model) => City.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listCities = listC;
          City allinst = new City(9999, "Sve institucije");
          city = allinst;
          listCities.add(allinst);
        });
      }
    });
  }

  _getInstitutionFromCity(int cityId) {
    APIServices.getInstitutionByCityIdAuth(TokenSession.getToken, cityId)
        .then((res) {
      Iterable list = json.decode(res.body);
      List<Institution> listFU = List<Institution>();
      listFU = list.map((model) => Institution.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          filteredInstitution = listFU;
        });
      }
    });
  }

  _getInstitutionFromCityUnauth(int cityId) {
    APIServices.getInstitutionByCityIdUnauth(TokenSession.getToken, cityId)
        .then((res) {
      Iterable list = json.decode(res.body);
      List<Institution> listFU = List<Institution>();
      listFU = list.map((model) => Institution.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          filteredUnauthInstitution = listFU;
        });
      }
    });
  }

  _sortListBy() {
    if (filteredInstitution == null) {
      if (maxMinF == null || maxMinF.name == "Rastući")
        listInstitutions.sort((x, y) => x.postsNum.compareTo(y.postsNum));
      else if (maxMinF.name == "Opadajući")
        listInstitutions.sort((x, y) => y.postsNum.compareTo(x.postsNum));
    } else {
      if (maxMinF == null || maxMinF.name == "Rastući")
        filteredInstitution.sort((x, y) => x.postsNum.compareTo(y.postsNum));
      else if (maxMinF.name == "Opadajući")
        filteredInstitution.sort((x, y) => y.postsNum.compareTo(x.postsNum));
    }
  }

  void initState() {
    super.initState();
    _getInstitutions();
    _getUnauthInstitutions();
    _getCities();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, int id, int index, int page) {
    Widget okButton = FlatButton(
      child: Text(
        "Obriši",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        APIServices.deleteInstitution(TokenSession.getToken, id);
        setState(() {
          if (page == 1) {
            listInstitutions.removeAt(index);
          } else if (page == 2) {
            listUnauthInstitutions.removeAt(index);
          }
        });
        Navigator.pop(context);
      },
    ).showCursorOnHover;

    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: greenPastel),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ).showCursorOnHover;

    AlertDialog alert = AlertDialog(
      content: Text("Da li ste sigurni da želite da obrišete instituciju?",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        okButton,
        notButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogAccept(
      BuildContext context, int id, String email, int index, int page) {
    Widget okButton = FlatButton(
      child: Text(
        "Prihvati",
        style: TextStyle(color: greenPastel),
      ),
      onPressed: () {
        APIServices.acceptInstitution(TokenSession.getToken, id, email)
            .then((res) {
          if (res.statusCode == 200) {
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

    AlertDialog alert = AlertDialog(
      content: Text(
        "Da li ste sigurni da želite da prihvatite zahtev?",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        okButton,
        notButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget contactWidget(String phone, String email) => Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      child: Text("Broj telefona: ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      child: Text(phone,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ))),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Container(
                      child: Text("E-mail: ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Container(
                          child: Text(email,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              )))),
                ],
              )
            ]),
      );

  showAlertDialogDescription(String description, BuildContext contex) {
    showDialog(
        context: context,
        child: AlertDialog(
            title: Text('Opis institucije',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(description, style: TextStyle(fontSize: 14)),
                     SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "Izađi",
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  Widget nameInst(String name) => Container(
        child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget instPhoto(String photoPath) => Container(
        child: CircleImage(
          userPhotoURL + photoPath,
          imageSize: 56.0,
          whiteMargin: 2.0,
          imageMargin: 6.0,
        ),
      );

  Widget descInst(String description, BuildContext context) => Container(
          child: FlatButton(
        color: greenPastel,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0)),
        child: Text('Opis institucije', style: TextStyle(color: Colors.white)),
        onPressed: () {
          showAlertDialogDescription(description, context);
        },
      ).showCursorOnHover);

  Widget deleteInst(BuildContext context, int id, int index) => Container(
          child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: Colors.redAccent)),
        color: Colors.redAccent,
        child: Text(
          "Obriši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showAlertDialog(context, id, index, 1);
        },
      ).showCursorOnHover);

  Widget deleteAccept(BuildContext context, int id, int index) => Container(
          child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: Colors.redAccent)),
        color: Colors.redAccent,
        child: Text(
          "Obriši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showAlertDialog(context, id, index, 2);
        },
      ).showCursorOnHover);

  Widget acceptRequest(BuildContext context, int id, String email, int index) =>
      Container(
          child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: greenPastel)),
        color: greenPastel,
        child: Text(
          "Prihvati",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showAlertDialogAccept(context, id, email, index, 2);
        },
      ).showCursorOnHover);

  Widget dropdownFirstRow(List<City> listCities) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Grad: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          listCities != null
              ? new DropdownButton<City>(
                  hint: Text("Izaberi"),
                  value: city,
                  onChanged: (City newValue) {
                    setState(() {
                      city = newValue;
                    });
                    if (newValue.name == "Sve institucije") {
                      filteredInstitution = null;
                      //_getInstitutions();
                      _sortListBy();
                    } else {
                      _getInstitutionFromCity(newValue.id);
                      _sortListBy();
                    }
                  },
                  items: listCities.map((City option) {
                    return DropdownMenuItem(
                      child: new Text(option.name),
                      value: option,
                    );
                  }).toList(),
                )
              : new DropdownButton<String>(
                  hint: Text("Izaberi"),
                  onChanged: null,
                  items: null,
                ),
          new Text("Rešene objave: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          DropdownButton<MaxMinDropDown>(
            hint: Text("Izaberi"),
            value: maxMinF,
            onChanged: (MaxMinDropDown newValue) {
              setState(() {
                maxMinF = newValue;
              });
              if (newValue.name == "Rastući") {
                _sortListBy();
              } else if (newValue.name == "Opadajući") {
                _sortListBy();
              }
            },
            items: maxMinFilter.map((MaxMinDropDown option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          ),
        ]);
  }

  Widget dropdownSecondRow(List<City> listCities) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Grad: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          listCities != null
              ? new DropdownButton<City>(
                  hint: Text("Izaberi"),
                  value: cityU,
                  onChanged: (City newValue) {
                    setState(() {
                      cityU = newValue;
                    });
                    if (newValue.name == "Sve institucije") {
                      filteredUnauthInstitution = null;
                      _getUnauthInstitutions();
                    } else {
                      _getInstitutionFromCityUnauth(newValue.id);
                    }
                  },
                  items: listCities.map((City option) {
                    return DropdownMenuItem(
                      child: new Text(option.name),
                      value: option,
                    );
                  }).toList(),
                )
              : new DropdownButton<String>(
                  hint: Text("Izaberi"),
                  onChanged: null,
                  items: null,
                ),
        ]);
  }

  Widget institutionSolvedPosts(int index) => Container(
          child: Column(
        children: [
          Text("Rešene objave",
              style: TextStyle(
                color: Colors.black,
              )),
          Text("$index",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
        ],
      ));

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
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                width: 190,
                                child: nameInst(listInst[index].name)),
                            /*instPhoto(
                              listInst[index].photoPath,
                            ),*/
                            Container(
                                width: 200,
                                child: contactWidget(listInst[index].phone,
                                    listInst[index].email)),
                            Container(
                                width: 100,
                                child: institutionSolvedPosts(listInst[index].postsNum)),
                            descInst(listInst[index].description, context),
                            deleteInst(context, listInst[index].id, index),
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
                  child: Center(
                      child: Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 190,
                              child: nameInst(listInst[index].name)),
                          /*instPhoto(
                            listInst[index].photoPath,
                          ),*/
                          Container(
                              width: 200,
                              child: contactWidget(listInst[index].phone,
                                  listInst[index].email)),
                          descInst(listInst[index].description, context),
                          deleteAccept(context, listInst[index].id, index),
                          acceptRequest(
                            context,
                            listInst[index].id,
                            listInst[index].email,
                            index,
                          )
                        ]),
                  ]))),
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
          cursorColor: Colors.black,
          onChanged: (string) {
            _debouncer.run(() {
              setState(() {
                filteredInstitution = listInstitutions
                    .where((u) => (u.name.toLowerCase().contains(string.toLowerCase())))
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
        )).showCursorTextOnHover;
  }

  Widget searchUnath() {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: 550,
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: Colors.black,
          onChanged: (string) {
            _debouncer.run(() {
              setState(() {
                filteredUnauthInstitution = listUnauthInstitutions
                    .where((u) => (u.name.toLowerCase().contains(string.toLowerCase())))
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
        )).showCursorTextOnHover;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CenteredViewManageUser(
          child: TabBarView(children: <Widget>[
            Column(children: [
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  search(),
                ],
              ),
              dropdownFirstRow(listCities),
              Flexible(
                  child: filteredInstitution == null
                      ? (buildInstList(listInstitutions))
                      : buildInstList(filteredInstitution)),
            ]),
            Column(children: [
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  searchUnath(),
                ],
              ),
              dropdownSecondRow(listCities),
              Flexible(
                  child: filteredUnauthInstitution == null
                      ? buildUnauthInstList(listUnauthInstitutions)
                      : buildUnauthInstList(filteredUnauthInstitution)),
            ]),
          ]),
        ),
        CollapsingNavigationDrawer(),
      ],
    );
  }
}
