import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/createEvent/createEventPage.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventTablet.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:universal_html/html.dart';


class ManageEventsPageTablet extends StatefulWidget {
  @override
  ManageEventsPageTabletState createState() => ManageEventsPageTabletState();
}

class ManageEventsPageTabletState extends State<ManageEventsPageTablet>{
  List<Events> events;
  List<Events> finishedEvents;

  _getEvents()
  {
    APIServices.getEvents(TokenSession.getToken, 0).then((res) {
      Iterable list = json.decode(res.body);
      List<Events> ev;
      ev = list.map((model) => Events.fromObject(model)).toList();
      if(mounted)
      {
        setState(() {
          events = ev;
        });
      }
    });
  }

  _getFinishedEvents()
  {
    APIServices.getFinishedEvents(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Events> ev;
      ev = list.map((model) => Events.fromObject(model)).toList();
      if(mounted)
      {
        setState(() {
          finishedEvents = ev;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
    _getFinishedEvents();
  }

  Widget buildEventsList(List<Events> listEvents){
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: listEvents == null ? 0 : listEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Column(
                children: <Widget>[
                  titleColumn(listEvents[index].title, listEvents[index].shortDescription),
                  startEndDateRow(listEvents[index]),
                  locationRow(listEvents[index]),
                  buttonsRow(listEvents[index], index),
                 ],
                ),
              ),
          ],),
        );
      }
    );
  }

  Widget titleColumn(String title, String description) {
    return Column(children: <Widget>[
      SizedBox(height: 5.0,),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      description==null ? Text("") : Text(description),
    ],);
  }

  Widget startEndDateRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0),
      Column(children: <Widget>[
        Text("Počinje: "),
        Text(event.startDate),
      ],),
      Expanded(child: SizedBox(),),
      Column(children: <Widget>[
        Text("Završava se: "),
        Text(event.endDate),
      ],),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget locationRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 20.0,),
      Icon(Icons.location_on),
      Text(event.address),
    ],);
  }
 
  Widget buttonsRow(Events event, index) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewEventTablet(event)),
          );
        },
        color: Color(0xFF00BFA6),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        child: Text("Više informacija", style: TextStyle(color: Colors.white,),),
      ),
      Expanded(child: SizedBox()),
      RaisedButton(
        child: Text("Obriši", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        onPressed: () {
          showAlertDialog(context, event.id, index);
        },
      ),
      SizedBox(width: 15.0,),
    ],);
  }

  showAlertDialog(BuildContext context, int eventId, int index) {
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: Colors.red),),
      onPressed: () {
        APIServices.removeEvent(TokenSession.getToken, eventId).then((res) {
          if(res.statusCode == 200){
            print("Događaj je uspešno obrisan.");
            setState(() {
              events.removeAt(index);
            });
          }
        });
        Navigator.pop(context);
        },
    );
    
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Color(0xFF00BFA6)),),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Brisanje događaja"),
      content: Text("Da li ste sigurni da želite da obrišete događaj?"),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(child: ConstrainedBox(child: TabBarView(children: <Widget>[
          Column(children: <Widget>[
           Row(children: <Widget>[
           Expanded(child: SizedBox(),),
           RaisedButton(onPressed: () {
             Navigator.pushReplacement(context, 
               MaterialPageRoute(builder: (context) => CreateEventPage()),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
            child: Row(children: <Widget>[ Text("Dodaj dogđaj", style: TextStyle(color: Colors.white),), Icon(Icons.add, color: Colors.white,)],),
            color: Color(0xFF00BFA6),
          ),
          ],),
            Flexible(child: buildEventsList(events),),
          ]),
          Column(children: <Widget>[
          Flexible(child: buildEventsList(finishedEvents),),
          ]),
          ],),
          constraints: BoxConstraints(maxWidth: 500),
          ),
          padding: const EdgeInsets.only(left: 100, right: 100, top: 30),
          alignment: Alignment.topCenter,
        ),

        CollapsingNavigationDrawer(),
      ],
    );
  }
}