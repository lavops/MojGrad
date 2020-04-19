import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend/models/donation.dart';
import 'package:frontend/ui/homePage.dart';

class DonationsWidget extends StatefulWidget {
  final Donation donation;

  DonationsWidget(this.donation);

  @override
  _DonationsWidgetState createState() => _DonationsWidgetState(donation);
}

class _DonationsWidgetState extends State<DonationsWidget> {
  Donation donation;
  TextEditingController donateController = new TextEditingController();

  _DonationsWidgetState(Donation donation1) {
    this.donation = donation1;
  }

  @override
  Widget build(BuildContext context) {
    return buildEvent();
  }

  Widget buildEvent() =>Card(
    child: Column(
      children: <Widget>[
        eventInfoRow(),
        SizedBox(height: 10.0,),
        titleRow(),
        descriptionRow(),
        eventProgressRow(),
        pointsRow(),
        actionButtonRow()
      ]
    )
  );

  Widget eventInfoRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text(
          donation.organizationName, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
        ),
        Expanded(child: SizedBox()),
        SizedBox(width: 10.0,),
      ]
    );
  }

  Widget titleRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          Flexible(child: Text(donation.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget eventProgressRow(){
    return IconRoundedProgressBar(
      icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: (donation.pointsAccumulated / donation.pointsNeeded) * 84, // 84
    );
  }

  Widget eventProgressInfoRow(){
    return IconRoundedProgressBar(
      icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: (donation.pointsAccumulated / donation.pointsNeeded) * 52, // 52
    );
  }

  Widget pointsRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text("Skupljeno: "),
        Text("${donation.pointsAccumulated} poena"),
        Expanded(child: SizedBox()),
        Text("Potrebno: "),
        Text("${donation.pointsNeeded} poena"),
        SizedBox(width: 10.0,),
      ],
    );
  }

  Widget descriptionRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          (donation.description != null)?
            Flexible(child: Text(donation.description)) :
            Text("Nema opis."),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget actionButtonRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        FlatButton(
          onPressed: (){
            moreInfoActionButton();
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.green[800]
          )
        ),
          child: Text("Vise informacija"),
        ),
        Expanded(child: SizedBox()),
        RaisedButton(
          onPressed: (){
            donateActionButton();
          },
          color: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.green[800]
          )
        ),
          child: Text("Doniraj", style: TextStyle(color: Colors.white),),
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }

  donateActionButton(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Doniraj poene."),
        content: Container(
          height: 70.0,
          child: Column(
            children: <Widget>[
              Text("Imate ukupno " + publicUser.points.toString() + " poena!"),
              TextField(
                controller: donateController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Doniraj",
              style: TextStyle(color: Colors.green[800]),
            ),
            onPressed: () {
              
              print('Uspesno ste donirali.');
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
          child: Text(
            "Otkazi",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

  moreInfoActionButton(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Informacije o dogadjaju."),
        content: Container(
          height: double.infinity,
          width: 400.0,
          child: Column(
            children: <Widget>[
              Text(
                donation.organizationName, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
              ),
              SizedBox(height: 10.0,),
              eventProgressInfoRow(),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Skupljeno:"),
                      Text("${donation.pointsAccumulated} poena")
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Column(
                    children: <Widget>[
                      Text("Potrebno:"),
                      Text("${donation.pointsNeeded} poena")
                    ],
                  )
                ],
              ),
              Text("Ucestvuje: ${donation.userNum} korisnika"),
              SizedBox(height: 20.0,),
              Flexible(child: Text(donation.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
              Flexible(child: Text(donation.description)),
            ]
          ),
        ),
        actions: <Widget>[
          FlatButton(
          child: Text(
            "Izadji",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

}