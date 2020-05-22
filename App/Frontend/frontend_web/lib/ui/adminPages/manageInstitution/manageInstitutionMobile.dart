import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionDesktop.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import '../../../models/city.dart';

class ManageInstitutionMobile extends StatefulWidget {
  @override
  _ManageInstitutionMobileState createState() =>
      _ManageInstitutionMobileState();
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

class _ManageInstitutionMobileState extends State<ManageInstitutionMobile>
    with SingleTickerProviderStateMixin {
  List<Institution> listInstitutions;
  List<Institution> listUnauthInstitutions;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<Institution> filteredInstitution;
  List<Institution> filteredUnauthInstitution;

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
    // set up the button
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
    // set up the button
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
    );
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

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
                  Expanded(
                      child: Container(
                          child: Text(phone,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              )))),
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

  Widget descriptionWidget(String description) => Container(
        width: 400,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(description),
          ],
        ),
      );

  Widget nameInst(String name) => Container(
        child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget institutionSolvedPosts(int index) => Container(
          child: Row(
        children: [
          Text("Broj rešenih objava: ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Text(
            "$index",
          )
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
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                          width: 190, child: nameInst(listInst[index].name)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                    width: 200,
                                    child: contactWidget(listInst[index].phone,
                                        listInst[index].email)),
                                Container(
                                    width: 200,
                                    child: institutionSolvedPosts(listInst[index].postsNum)),
                              ],
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String choice) {
                                choiceActionAllInstitutions(
                                    choice,
                                    listInst[index].id,
                                    listInst[index].description,
                                    index);
                              },
                              itemBuilder: (BuildContext context) {
                                return ConstantsAllInstitutions.choices
                                    .map((String choice) {
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

  void choiceActionAllInstitutions(
      String choice, int institutionId, String description, int index) {
    if (choice == ConstantsAllInstitutions.OpisInstitucije) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Opis institucije",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 300,
              child: descriptionWidget(description),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izađi",
                  style: TextStyle(color: greenPastel),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsAllInstitutions.ObrisiInstitutciju) {
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
                      child: Column(children: <Widget>[
                    Container(
                        width: 190, child: nameInst(listInst[index].name)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 200,
                                  child: contactWidget(listInst[index].phone,
                                      listInst[index].email)),
                            ],
                          ),
                          PopupMenuButton<String>(
                            onSelected: (String choice) {
                              choiceActionRequestsInstitutions(
                                  choice,
                                  listInst[index].id,
                                  listInst[index].description,
                                  listInst[index].email,
                                  index);
                            },
                            itemBuilder: (BuildContext context) {
                              return ConstantsRequestsInstitutions.choices
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ])
                  ]))),
            ],
          ),
        ));
      },
    );
  }

  void choiceActionRequestsInstitutions(String choice, int institutionId,
      String description, String email, int index) {
    if (choice == ConstantsRequestsInstitutions.OpisInstitucije) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Opis institucije",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 300,
              child: descriptionWidget(description),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izađi",
                  style: TextStyle(color: greenPastel),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsRequestsInstitutions.ObrisiInstitutciju) {
      showAlertDialog(context, institutionId, index, 2);
    } else if (choice == ConstantsRequestsInstitutions.PrihvatiInstitutciju) {
      showAlertDialogAccept(context, institutionId, email, index, 2);
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
        ));
  }

  Widget searchUnath() {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: 300,
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
        ));
  }

  Widget dropdownFirstRow(List<City> listCities) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          )
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
          dropdownFirstRow(listCities),
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
          dropdownSecondRow(listCities),
          Flexible(
              child: filteredUnauthInstitution == null
                  ? buildUnauthInstList(listUnauthInstitutions)
                  : buildUnauthInstList(filteredUnauthInstitution)),
        ]),
      ]),
    );
  }
}

class MaxMinDropDown {
  int id;
  String name;

  MaxMinDropDown(this.id, this.name);

  static List<MaxMinDropDown> getMaxMinDropDown() {
    return <MaxMinDropDown>[
      MaxMinDropDown(1, "Rastući"),
      MaxMinDropDown(2, "Opadajući"),
    ];
  }
}
