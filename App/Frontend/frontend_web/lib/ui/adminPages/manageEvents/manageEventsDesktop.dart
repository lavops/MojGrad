import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/createEvent/createEventPage.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:universal_html/html.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

class ManageEventsPageDesktop extends StatefulWidget {
  @override
  ManageEventsPageDesktopState createState() => ManageEventsPageDesktopState();
}

class ManageEventsPageDesktopState extends State<ManageEventsPageDesktop>{
  List<Events> events;

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

  @override
  void initState() {
    super.initState();
    _getEvents();
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
      Text("Počinje: "),
      Text(event.startDate),
      Expanded(child: SizedBox(),),
      Text("Završava se: "),
      Text(event.endDate),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget locationRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 10.0,),
      Icon(Icons.location_on),
      Text(event.address),
    ],);
  }

  Widget buttonsRow(Events event, index) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      RaisedButton(
        onPressed: () {},
        color: Color(0xFF00BFA6),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        child: Text("Više informacija", style: TextStyle(color: Colors.white,),),
      ).showCursorOnHover,
      Expanded(child: SizedBox()),
      RaisedButton(
        child: Text("Obriši", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        onPressed: () {
          showAlertDialog(context, event.id, index);
        },
      ).showCursorOnHover,
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
        okButton.showCursorOnHover,
        notButton.showCursorOnHover,
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
        Container(child: ConstrainedBox(child: Column(children: <Widget>[
           Row(children: <Widget>[
           Expanded(child: SizedBox(),),
           RaisedButton(onPressed: () {
             Navigator.pushReplacement(context, 
               MaterialPageRoute(builder: (context) => CreateEventPage()),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
            child: Row(children: <Widget>[ Text("Dodaj događaj", style: TextStyle(color: Colors.white),), Icon(Icons.add, color: Colors.white,)],),
            color: Color(0xFF00BFA6),
          ).showCursorOnHover,
          ],),
            Flexible(child: buildEventsList(events),),
          ]),
          constraints: BoxConstraints(maxWidth: 600),
          ),
          padding: const EdgeInsets.only(left: 100, right: 100, top: 30),
          alignment: Alignment.topCenter,
        ),

        CollapsingNavigationDrawer(),
      ],
    );
  }
}