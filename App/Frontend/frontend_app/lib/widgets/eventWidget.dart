import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/models/event.dart';
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
    return buildEvent();
  }

  Widget buildEvent() =>Card(
    child: Column(
      children: <Widget>[
        eventInfoRow(),
        startEndDate(),
        SizedBox(height: 10.0,),
        titleRow(),
        descriptionRow(),
        SizedBox(height: 10.0,),
        actionButtonRow()
      ]
    )
  );

  Widget eventInfoRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text(
          event.organizeName, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
        ),
        Expanded(child: SizedBox()),
        Icon(Icons.location_on),
        Text(event.cityName),
        SizedBox(width: 10.0,),
      ]
    );
  }
  
  Widget startEndDate(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text("Pocetak: "),
        Text(event.startDate.toString()),
        Expanded(child: SizedBox()),
        Text("Zavrsetak: "),
        Text(event.endDate.toString()),
        SizedBox(width: 10.0,),
      ],
    );
  }

  Widget titleRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          Flexible(child: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget descriptionRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          (event.shortDescription != null)?
            Flexible(child: Text(event.shortDescription)) :
            Text("Nema kratak opis."),
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
        (event.isGoing != 1) ?
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
              leaveEventActionButton();
            },
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red
            )
          ),
            child: Text("Otkazi", style: TextStyle(color: Colors.white)),
          ),
        SizedBox(width: 10.0,),
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

  leaveEventActionButton(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Otkazi prisustvo dogadjaju!"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Potvrdi",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              print('Uspesno ste otkazali prisustvo dogadjaju.');
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
          child: Text(
            "Otkazi",
            style: TextStyle(color: Colors.green[800]),
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
            children: <Widget>[
              Text(
                event.organizeName, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Datum pocetka:"),
                      Text(event.startDate)
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Column(
                    children: <Widget>[
                      Text("Datum zavrsetka:"),
                      Text(event.endDate)
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0,),
              showMap(),
              SizedBox(height: 20.0,),
              Flexible(child:Text(event.address)),
              SizedBox(height: 10.0,),
              Text("Ucestvuje: ${event.userNum} korisnika"),
              SizedBox(height: 20.0,),
              Flexible(child: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
              SizedBox(height: 10.0,),
              Flexible(child: Text(event.description)),
              SizedBox(height: 20.0,),
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

  Widget showMap(){
    return Container(
      height: 200,
      width: double.infinity,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(event.latitude, event.longitude), //event.latitude, event.longitude
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
                point: new LatLng(event.latitude, event.longitude), //event.latitude, event.longitude
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