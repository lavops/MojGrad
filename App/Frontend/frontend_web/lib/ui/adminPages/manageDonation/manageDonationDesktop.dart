import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewDonation.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageDonationDesktop extends StatefulWidget {
  @override
  _ManageDonationDesktopState createState() => _ManageDonationDesktopState();
}

class _ManageDonationDesktopState extends State<ManageDonationDesktop>{
  
  List<Donation> donations;

  _getDonations() async {
    APIServices.getDonations(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Donation> donations1 = List<Donation>();
      donations1 = list.map((model) => Donation.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          donations = donations1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CenteredViewDonation(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: SizedBox(),),
                  RaisedButton(
                    onPressed: (){
                      
                    },
                    color: greenPastel,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: greenPastel)
                  ),
                    child: Text("Nova donacija", style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(width: 10.0,),
                ],
              ),
              Flexible(child: buildDonationList(donations),)
            ],
          )
        ),
        CollapsingNavigationDrawer()
      ],
    );
  }

  Widget buildDonationList(List<Donation> listDonations){
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: donations == null ? 0 : donations.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Row(
            children: <Widget>[
              Expanded(child:Column(children: <Widget>[
                eventInfoRow(donations[index].organizationName),
                SizedBox(height: 10.0,),
                titleRow(donations[index].title),
                descriptionRow(donations[index].description),
                eventProgressRow(donations[index].pointsAccumulated, donations[index].pointsNeeded),
                pointsRow(donations[index].pointsAccumulated, donations[index].pointsNeeded),
                actionButtonRow(donations[index], donations[index].id, index)
              ]),),
              Container(
                color: (donations[index].pointsAccumulated >= donations[index].pointsNeeded) ? greenPastel: Colors.white,
                child: SizedBox(width: 20,),
              )
            ],
          )
        );
      }
    );
  }

  Widget eventInfoRow(String organizationName){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text(
          organizationName, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
        ),
        Expanded(child: SizedBox()),
        SizedBox(width: 10.0,),
      ]
    );
  }

  Widget titleRow(String title){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          Flexible(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget eventProgressRow(int pointsAccumulated, int pointsNeeded){
    return IconRoundedProgressBar(
      icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: (pointsAccumulated / pointsNeeded) * 84, // 84
    );
  }

  Widget pointsRow(int pointsAccumulated, int pointsNeeded){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text("Skupljeno: "),
        Text("$pointsAccumulated poena"),
        Expanded(child: SizedBox()),
        Text("Potrebno: "),
        Text("$pointsNeeded poena"),
        SizedBox(width: 10.0,),
      ],
    );
  }

  Widget descriptionRow(String description){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          (description != null)?
            Flexible(child: Text(description)) :
            Text("Nema opis."),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget actionButtonRow(Donation don, int id, int index){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        RaisedButton(
          onPressed: (){
            
          },
          color: greenPastel,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: greenPastel)
        ),
          child: Text("Više informacija", style: TextStyle(color: Colors.white)),
        ),
        Expanded(child: SizedBox(),),
        RaisedButton(
          onPressed: (){
            showAlertDialog(context, id, index);
          },
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.red)
        ),
          child: Text("Obriši", style: TextStyle(color: Colors.white),),
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }

  showAlertDialog(BuildContext context, int id, int index) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: Colors.red),),
      onPressed: () {
        APIServices.deleteDonation(TokenSession.getToken, id).then((res) {
          if(res.statusCode == 200){
            print("Uspesno brisanje donacije.");
            setState(() {
              donations.removeAt(index);
            });
          }
        });
        Navigator.pop(context);
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje Donacije"),
      content: Text("Da li ste sigurni da želite da obrišete donaciju?"),
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
}