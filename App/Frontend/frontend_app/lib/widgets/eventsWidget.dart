import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend/models/events.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:latlong/latlong.dart';

class EventsWidget extends StatefulWidget {
  final Events event;

  EventsWidget(this.event);

  @override
  _EventsWidgetState createState() => _EventsWidgetState(event);
}

class _EventsWidgetState extends State<EventsWidget> {
  Events event;
  TextEditingController donateController = new TextEditingController();

  _EventsWidgetState(Events event1) {
    this.event = event1;
  }

  @override
  Widget build(BuildContext context) {
    return (event.eventType == 1)?simpleEvent():sponsorEvent();
  }

  Widget simpleEvent()=>Card(
    child: Column(
      children: <Widget>[
        eventInfoRow(),
        startEndDate(),
        SizedBox(height: 20.0,),
        descriptionRow(),
        actionButtonRow()
      ],
    ),
  );

  Widget sponsorEvent()=>Card(
    child: Column(
      children: <Widget>[
        eventInfoRow(),
        startEndDate(),
        SizedBox(height: 20.0,),
        descriptionRow(),
        eventProgressRow(),
        pointsRow(),
        actionButtonRow()
      ],
    ),
  );

  Widget eventInfoRow(){
    return Row(
      children: <Widget>[
        CircleImage(
          serverURLPhoto + "Upload//ProfilePhoto//default.jpg",
          imageSize: 36.0,
          whiteMargin: 2.0,
          imageMargin: 6.0,
        ),
        Text("PMF Kragujevac",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
        Expanded(child: SizedBox()),
        (event.eventType == 1) ? Icon(Icons.event):Icon(Icons.attach_money),
        (event.eventType == 1) ? Text("DOGADJAJ"):Text("DONACIJA"),
      ],
    );
  }
  
  Widget startEndDate(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text("Pocetak: "),
        Text("4/14/2020"),
        Expanded(child: SizedBox()),
        Text("Zavrsetak: "),
        Text("4/24/2020"),
        SizedBox(width: 10.0,),
      ],
    );
  }

  Widget descriptionRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          Flexible(child: Text("Ovo je opis dogadjaja / donacije trebalo bi biti ovako i nzm sta ce biti ako ovo predje u novi red ali sad ce da vidimo kako to izgleda"))
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
      percent: 42, // delimo sa 84
    );
  }

  Widget eventProgressInfoRow(){
    return IconRoundedProgressBar(
      icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: 26, // delimo sa 52
    );
  }

  Widget pointsRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text("Skupljeno: "),
        Text("50 poena"),
        Expanded(child: SizedBox()),
        Text("Potrebno: "),
        Text("100 poena"),
        SizedBox(width: 10.0,),
      ],
    );
  }

  Widget actionButtonRow(){
    return Row(
      children: <Widget>[
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
        (event.eventType == 1) ?
        RaisedButton(
          onPressed: (){
            joinEventActionButton();
          },
          color: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.green[800]
          )
        ),
          child: Text("Pridruzi se", style: TextStyle(color: Colors.white)),
        ) :
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
      ],
    );
  }

  joinEventActionButton(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Pridruzi se dogadjaju!"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Pridruzi se",
              style: TextStyle(color: Colors.green[800]),
            ),
            onPressed: () {
              
              print('Uspesno ste pridruzili dogadjaju.');
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
          height: 500.0,
          width: 400.0,
          child: Column(
            children: (event.eventType == 1) ? 
            <Widget>[
              Text("PMF KRAGUJEVAC"),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Datum pocetka:"),
                      Text("4/14/2020")
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Column(
                    children: <Widget>[
                      Text("Datum zavrsetka:"),
                      Text("4/20/2020")
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0,),
              showMap(),
              SizedBox(height: 20.0,),
              Text("Jovana Ristica 12, Kragujevac, Srbija"),
              SizedBox(height: 10.0,),
              Text("Ucestvuje: 10 korisnika"),
              SizedBox(height: 20.0,),
              Flexible(child: Text("Ovo je opis dogadjaja / donacije trebalo bi biti ovako i nzm sta ce biti ako ovo predje u novi red ali sad ce da vidimo kako to izgleda")),
              SizedBox(height: 20.0,),
            ]:
            <Widget>[
              Text("PMF KRAGUJEVAC"),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Datum pocetka:"),
                      Text("4/14/2020")
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Column(
                    children: <Widget>[
                      Text("Datum zavrsetka:"),
                      Text("4/20/2020")
                    ],
                  )
                ],
              ),
              eventProgressInfoRow(),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Text("Potrebno: 100 poena"),
                    Text("Skupljeno: 50 poena"),
                    Text("Ucestvuje: 10 korisnika"),
                  ],
                )
              ),
              SizedBox(height: 20.0,),
              Flexible(child: Text("Ovo je opis dogadjaja / donacije trebalo bi biti ovako i nzm sta ce biti ako ovo predje u novi red ali sad ce da vidimo kako to izgleda")),
            ],
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

  Widget showMap(){
    return Container(
      height: 200,
      width: double.infinity,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(44.008852,20.923006), //event.latitude, event.longitude
          zoom: 15,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/lavops/ck8m295d701du1iqid1ejoqxu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ',
                'id': 'mapbox.mapbox-streets-v7'
              }),
          new MarkerLayerOptions(
            markers:[
              Marker(
                point: new LatLng(44.008852,20.923006), //event.latitude, event.longitude
                builder: (ctx) => new Container(
                    child: Icon(Icons.location_on, color: Colors.red,)
                ),
              ),
            ]
          ),
        ],
      )
    );
  }
}