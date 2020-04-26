import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/ui/InstitutionPages/registerPage/registerPage.dart';
import 'package:frontend_web/ui/sponsorPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class InstitutionLoginPage extends StatefulWidget{
  @override
  _InstitutionLoginPageState createState() => new _InstitutionLoginPageState();
}

class _InstitutionLoginPageState extends State<InstitutionLoginPage>{
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        /*drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? NavigationDrawer()
            : null,*/
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              HomeNavigationBar(1),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: InstitutionAdminLoginMobilePage(),
                  desktop: InstitutionLoginDesktopPage(),
                  tablet: InstitutionAdminLoginMobilePage(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}

class InstitutionAdminLoginMobilePage extends StatefulWidget{
  @override
  _InstitutionLoginMobilePageState createState() => new _InstitutionLoginMobilePageState();
}

class _InstitutionLoginMobilePageState extends State<InstitutionAdminLoginMobilePage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100,),
            Image.asset('assets/undraw2.png'),
            InstitutionLoginPageWidget(),
          ],
        )
      ],
    );
  }
}

class InstitutionLoginDesktopPage extends StatefulWidget{
  @override
  _InstitutionLoginDesktopPageState createState() => new _InstitutionLoginDesktopPageState();
}

class _InstitutionLoginDesktopPageState extends State<InstitutionLoginDesktopPage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Row(children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset('assets/undraw2.png'),
            ),
          ),
          InstitutionLoginPageWidget(),
        ],)
      ]
    );
  }
}


class InstitutionLoginPageWidget extends StatefulWidget{
  @override
  _InstitutionLoginPageWidgetState createState() => new _InstitutionLoginPageWidgetState();
}

class _InstitutionLoginPageWidgetState extends State<InstitutionLoginPageWidget>{
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String pogresanLoginText = '';


  void initState(){
    super.initState();
 
  }

  _login(String _email, String _password){
    if( _email == '' || _password == '' )
    {
      _emailController.text = "";
      _passwordController.text = "";
      setState(() {
        pogresanLoginText = "Podaci nisu ispravni";
      });
      throw Exception('Los email/sifra');
    }
    else{
      var pom = utf8.encode(_password);
      var pass = sha1.convert(pom);
      APIServices.loginInstitution(_email, pass.toString()).then((response){
         if (response != null) {
          TokenSession.setToken = response;
          print(response);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => InstitutionPage.fromBase64(response)));
        }
         else {
          _passwordController.text = "";
          setState(() {
            pogresanLoginText = "PODACI NISU ISPRAVNI";
          });
          throw Exception('Bad username/password');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){

    //text box for email
    final emailText = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email,color: Colors.green[800]),
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: Colors.green[800]),
        ),
      ),
      controller: _emailController,
    );

    //text box for password
    final passwordText = TextField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: Colors.green[800],),
        hintText: 'Šifra',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: Colors.green[800]),
        ),
      ),
      controller: _passwordController,
    );

    //button for login
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(50.0),
        shadowColor: Colors.lightGreenAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0),
            side: BorderSide(color: Colors.transparent)
          ),
          onPressed: (){
            // Call login function
            _login(_emailController.text, _passwordController.text);
            
          },
          color: Colors.green[800],
          child: Text(
            'Uloguj se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    //in case of wrong login
    final pogresanLogin = Center( child: Text(
        '$pogresanLoginText',
        style: TextStyle(color: Colors.red),
      )
    );

      final registrationLabelWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child:Text('Da li želite da se registrujete? ')),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Flexible(
            child: Text(
            'Registruj me.',
            style: TextStyle(
                color: Colors.green[800], fontWeight: FontWeight.bold),
          ),),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InstitutionRegisterPage()),
            );
          },
        ),
      ],
    );


    return Container(
            width: 400,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 48.0,),
                    emailText,
                    SizedBox(height: 8.0,),
                    passwordText,
                    SizedBox(height: 24.0,),
                    loginButton,
                    registrationLabelWidget,
                  ], 
                ),
                SizedBox(height: 8.0,),
                pogresanLogin,
              ],
            ),
          );
  }
}