import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/ui/loginSponsorPage.dart';
import 'package:frontend_web/ui/sponsorPage.dart';
import '../models/city.dart';
import '../models/user.dart';
import '../services/api.services.dart';
import '../services/token.session.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';


class EditInstitutionPage extends StatefulWidget {

  final int insId;

  EditInstitutionPage({Key key, this.insId,});

  @override
  _EditInstitutionPageState createState() => _EditInstitutionPageState();
}

class _EditInstitutionPageState extends State<EditInstitutionPage> {

  String wrongRegText = "";
  Institution institution;
  String ime = "";


  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController newName = new TextEditingController();
  TextEditingController newDescription = new TextEditingController();
  TextEditingController newEmail = new TextEditingController();
  TextEditingController newMobile = new TextEditingController();
  TextEditingController newPassword1 = new TextEditingController();
  TextEditingController newPassword2 = new TextEditingController();

  bool _secureText = true;

  @override
  void initState() {
    super.initState();
    _getCity();
    _getInsData(TokenSession.getToken, widget.insId);
  }


  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  _getInsData(String jwt, int id) async {
    var result = await APIServices.getInstitutionById(jwt, id);
    Map<String, dynamic> jsonUser = jsonDecode(result.body);
    Institution ins = Institution.fromObject(jsonUser);
    setState(() {
      institution = ins;
    });
  }


  showDialogName(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EditInstitutionPage(insId: insId,)),
        );
      },
    );

    Widget newNameField = TextField(
      controller: newName,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Promena imena institucije"),
      content: newNameField,
      actions: [
        okButton,
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

  showDialogDescription(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
      },
    );
    Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.green),),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EditInstitutionPage(insId:insId)),
        );
      },
    );

    Widget newDescriptionField = TextField(
      controller: newDescription,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Promena opisa institucije"),
      content: newDescriptionField,
      actions: [
        okButton,
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


  showDialogEmail(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
      },
    );

    Widget newEmailField = TextField(
      controller: newEmail,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Promena mail - a institucije"),
      content: newEmailField,
      actions: [
        okButton,
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

 showDialogMobile(BuildContext context) {
   // set up the button
   Widget okButton = FlatButton(
     child: Text(
       "OK",
       style: TextStyle(color: Colors.green),
     ),
     onPressed: () {
     },
   );

   Widget newMobileField = TextField(
     controller: newMobile,
   );

   // set up the AlertDialog
   AlertDialog alert = AlertDialog(
     title: Text("Promena telefona institucije"),
     content: newMobileField,
     actions: [
       okButton,
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

  showDialogPassword(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
      },
    );

    Widget newPassword1Field = TextField(
      controller: newPassword1,
    );
    Widget newPassword2Field = TextField(
      controller: newPassword2,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Promena lozinke institucije"),
      content: Text('Ponovite staru lozinku, a zatim unesite novu: '),
      actions: [
        newPassword1Field,
        newPassword2Field,
        okButton,
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




  showDialogCity(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
      },
    );
    Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.redAccent),),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EditInstitutionPage(insId: insId)),
        );
      },
    );

    Widget dropdownWidget =new Container(
      height:220,
        child:new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Izaberite svoj grad: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
          new Container(
            padding: new EdgeInsets.all(16.0),
          ),
          _city != null
              ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: city,
            onChanged: (City newValue) {
              setState(() {
                city = newValue;
              });
            },
            items: _city.map((City option) {
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
        ]));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Promena grada institucije"),
      content: dropdownWidget,
      actions: [
        okButton
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

  List<City> _city;
  City city;

  _getCity() {
    APIServices.getCity1().then((res) {
      Iterable list = json.decode(res.body);
      List<City> listC = List<City>();
      listC = list.map((model) => City.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          _city = listC;
        });
      }
    });
  }

  final deactLabelWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('Želite da deaktivirate nalog Vaše institucije? '),
      SizedBox(
        width: 5.0,
      ),
      InkWell(
        child: Text(
          'Deaktiviraj nalog.',
          style: TextStyle(
              color: Colors.redAccent[800], fontWeight: FontWeight.bold),
        ),
        onTap: () {
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {

    name.text = institution.name;
    email.text = institution.email;
    mobile.text = institution.phone;
    description.text = institution.description;
    ime = name.text;

      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text('Izmena podataka institucije'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  String jwt = TokenSession.getToken;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstitutionPage.fromBase64(jwt)));
                }),
          ),
        body:Row(children: <Widget>[
            CollapsingInsNavigationDrawer(),
            SizedBox(width: 540,),
            Center(
    child:Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 5),
          width:500,
          child:ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.business,  color: Colors.green[800]),
              title: Text('Naziv institucije'),
              subtitle: Text(institution.name),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
               child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showDialogName(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.description,  color: Colors.green[800]),
              title: Text('Opis'),
              subtitle: Text(institution.description),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showDialogDescription(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.email,  color: Colors.green[800]),
              title: Text('Email'),
              subtitle: Text(institution.email),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showDialogEmail(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green[800]),
              title: Text('Telefon'),
              subtitle: Text(institution.phone),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showDialogMobile(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_city, color: Colors.green[800]),
              title: Text('Grad'),
              subtitle: Text(institution.cityName),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showDialogCity(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.phonelink_lock, color: Colors.green[800]),
              title: Text('Šifra'),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showDialogPassword(context);
                },
              ),
            ),
           Center(
             child: Container(
              width: 500,
              child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.green[800])),
              color: Colors.green[800],
              child: Text(
                "Sacuvaj izmene",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                  if (city != null) {
                    edit(newName.text, newDescription.text, newEmail.text, newMobile.text, city.id, institution, newPassword1.text, newPassword2.text);
                  }
                  else {
                    edit(newName.text, newDescription.text, newEmail.text, newMobile.text, 0, institution, newPassword1.text, newPassword2.text);
                  }

              },
            ))),
           Center(
                child: Text(
                '$wrongRegText',
                style: TextStyle(
                color: Colors.red,
                fontSize: 25,
                ),
                )),
            deactLabelWidget,
          ],

        ),
      ))])));
  }



  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        String jwt = TokenSession.getToken;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstitutionPage.fromBase64(jwt)),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uspešna promena podataka"),
      content: Text("Promenili ste podatke"),
      actions: [
        okButton,
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




  edit(String nname, String ndescription, String nemail, String nmobile, int ncityId, Institution institution, String pass1, String pass2) {

    final nameRegex = RegExp(r'^[a-zA-Z]{1,30}$');
    final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,6}[.][a-z]{2,3}$');
    final mobRegex = RegExp(r'^06[0-9]{7,8}$');

    if (ncityId == 0) {
      ncityId = institution.cityId;
    }

    if (nname == "") {
      nname = institution.name;
    }
    if (ndescription == "") {
      ndescription = institution.description;
    }
    if (nemail == "") {
      nemail = institution.email;
    }
    if (nmobile == "") {
      nmobile = institution.phone;
    }

    if (nameRegex.hasMatch(nname)) {
        if (emailRegex.hasMatch(nemail)) {
          if (mobRegex.hasMatch(nmobile)) {
              if (pass1 == "" && pass2 == "") {
                String jwt = TokenSession.getToken;
                APIServices.editInstitutionData(jwt, institution.id, nname, nemail, nmobile, ndescription, ncityId);
                setState(() {
                  showAlertDialog(context);
                });
              }
              else {
                if (pass1 == pass2) {
                  setState(() {
                    wrongRegText = "Unesite ponovo lozinku.";
                  });
                  throw Exception("Ne poklapaju se lozinke");
                }
                String jwt = TokenSession.getToken;

                var tempPass1 = utf8.encode(pass1);
                var shaPass1 = sha1.convert(tempPass1);
                var tempPass2 = utf8.encode(pass2);
                var shaPass2 = sha1.convert(tempPass2);

                APIServices.editInstitutionPassword(jwt, institution.id, shaPass1.toString(), shaPass2.toString()).then((res) {
                  if (res.statusCode == 200) {
                    setState(() {
                      showAlertDialog(context);
                    });
                  }
                  else {
                    setState(() {
                      wrongRegText = "Unesite ponovo podatke.";
                    });
                    throw Exception("Unesite ponovo podatke.");
                  }
                });
              }



            }
          else {
            setState(() {
              wrongRegText = "Unesite ponovo mobilni.";
            });
            throw Exception("Unesite ponovo mobilni.");
          }
        }
        else {
          setState(() {
            wrongRegText = "Unesite ponovo email.";
          });
          throw Exception("Unesite ponovo email.");
        }
      }
    else {
      setState(() {
        wrongRegText = "Molimo unesite ponovo naziv institucije.";
      });
      throw Exception("Molimo unesite ponovo naziv institucije.");
    }
  }




}