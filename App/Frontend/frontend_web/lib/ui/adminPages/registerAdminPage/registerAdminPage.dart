import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/admin.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/loginPage/loginPage.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:responsive_builder/responsive_builder.dart';


class RegisterAdminPage extends StatefulWidget {
  @override
  _RegisterAdminPageState createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  
  @override
  Widget build(BuildContext context) {
     return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
         appBar: AppBar(
              title: Text('Izmena podataka institucije', style: TextStyle(color: Colors.black45),),
              backgroundColor: Colors.white60,
        ),
        backgroundColor: Colors.white,
        body: Row(
            children: <Widget>[
              sizingInformation.deviceScreenType != DeviceScreenType.Mobile 
            ? CollapsingNavigationDrawer(): SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile:AdminRegisterMobilePage(),
                  desktop: AdminRegisterDesktopPage(),
                  tablet: AdminRegisterDesktopPage(),
                ),
              )
            ],
          ),
        )
    );

  }
}


class AdminRegisterMobilePage extends StatefulWidget{
  @override
  _AdminRegisterMobilePageState createState() => new _AdminRegisterMobilePageState();
}

class _AdminRegisterMobilePageState extends State<AdminRegisterMobilePage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40,),
            Text("Unesite podatke o novom administratoru", style: TextStyle(color: Color.fromRGBO(15, 32, 67,100), fontSize: 25),),
            Container(width: 350, child: 
            AdminRegisterPageWidget(),
            ),
          ],
        )
      ],
    );
  }
}

class AdminRegisterDesktopPage extends StatefulWidget{
  @override
  _AdminRegisterDesktopPageState createState() => new _AdminRegisterDesktopPageState();
}

class _AdminRegisterDesktopPageState extends State<AdminRegisterDesktopPage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50,),
            Text("Unesite podatke o novom administratoru", style: TextStyle(color: Color.fromRGBO(15, 32, 67,100), fontSize: 25),),
            Container(width: 500, child: 
            AdminRegisterPageWidget(),
            ),
          ],
        )
      ],
    );
  }
}


class AdminRegisterPageWidget extends StatefulWidget{
  @override
  _AdminRegisterPageWidgetState createState() => new _AdminRegisterPageWidgetState();
}

class _AdminRegisterPageWidgetState extends State<AdminRegisterPageWidget>{
 String wrongRegText = "";

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _secureText = true;


  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterAdminPage()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uspešna registracija"),
      content: Text("Uspešno ste registrovali novog administratora"),
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

  _register(String firstName, String lastName, String email,String password) {
    final flNameRegex = RegExp(r'^[a-zA-Z]{1,10}$');
    final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
    final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,6}[.][a-z]{2,3}$');
   
    if (flNameRegex.hasMatch(firstName)) {
      if (flNameRegex.hasMatch(lastName)) {
            if (emailRegex.hasMatch(email)) {
              if (passRegex.hasMatch(password)) {
                var pom = utf8.encode(password);
                var pass = sha1.convert(pom);
                Admin adm = Admin.without(
                    firstName,
                    lastName,
                    pass.toString(),
                    email);
                APIServices.registration(adm).then((response) {
                  if (response.statusCode == 200) {
                    Map<String, dynamic> jsonObject =
                        json.decode(response.body);
                    User extractedUser = new User();
                    extractedUser = User.fromObject(jsonObject);
                    User user1;
                    setState(() {
                      user1 = extractedUser;
                      wrongRegText = "";
                    });
                    if (user1 != null) {
                      showAlertDialog(context);
                    }
                  } else {
                    setState(() {
                      wrongRegText = "Podaci nisu ispravni".toUpperCase();
                    });
                    throw Exception('Email ili username već zauseti');
                  }
                });
              } else {
                setState(() {
                  wrongRegText =
                      "Loša šifra. Šifra mora imati najmanje 6 karaktera."
                          .toUpperCase();
                });
                throw Exception(
                    "Loša sifra. Sifra mora imati najmanje 6 karaktera.");
              }
            } else {
              setState(() {
                wrongRegText = "Neispravan email.".toUpperCase();
              });
              throw Exception("Neispravan email.");
            }  
      } else {
        setState(() {
          wrongRegText = "Unesite ispravno prezime.".toUpperCase();
        });
        throw Exception("Unesite drugo prezime.");
      }
    } else {
      setState(() {
        wrongRegText = "Unestite ispravno ime.".toUpperCase();
      });
      throw Exception("Unesite drugo ime.");
    }
  }


  @override
  Widget build(BuildContext context) {

    final firstNameWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        controller: firstName,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Ime",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ),);

        final lastNameWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        controller: firstName,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Prezime",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ),);

     final emailWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        controller: email,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "E-mail",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.email, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ),);

    

   final passwordWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        obscureText: _secureText,
        controller: password,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Šifra",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          suffixIcon: IconButton(
            onPressed: showHide,
            icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                color: greenPastel),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.phonelink_lock, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ),);

    final registerButtonWidget = SizedBox(
      height: 48.0,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            "Registruj administratora",
            style: TextStyle(fontSize: 16.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          textColor: Colors.white,
          color: greenPastel,
          onPressed: () {
               _register(firstName.text, lastName.text, email.text, password.text);
          }),
    );

    final wrongReg = Center(
        child: Text(
      '$wrongRegText',
      style: TextStyle(color: Colors.red),
    ));
    return Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    wrongReg,
                    lastNameWidget,
                    firstNameWidget,
                    emailWidget,
                    passwordWidget,
                    SizedBox(
                      height: 12.0,
                    ),
                    registerButtonWidget,
                  ],
                ),
              );
  }
}
