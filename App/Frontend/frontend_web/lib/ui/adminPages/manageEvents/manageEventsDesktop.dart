import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/createEvent/createEventPage.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventDesktop.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewDonation.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:universal_html/html.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

import '../../../editEventPage.dart';

class ManageEventsPageDesktop extends StatefulWidget {
  @override
  ManageEventsPageDesktopState createState() => ManageEventsPageDesktopState();
}

class ManageEventsPageDesktopState extends State<ManageEventsPageDesktop>{
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

  Widget buildEventsList(List<Events> listEvents, int ind){
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 2,
        ),
      itemCount: listEvents == null ? 0 : listEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Column(
                children: <Widget>[
                  titleColumn(listEvents[index].title, listEvents[index].shortDescription),
                  Expanded(child: SizedBox()),
                  startEndDateRow(listEvents[index]),
                  Expanded(child: SizedBox()),
                  locationRow(listEvents[index]),
                  Expanded(child: SizedBox()),
                  buttonsRow(listEvents[index], index, listEvents, ind),
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
      SizedBox(width: 10.0,),
      Icon(Icons.location_on),
       Flexible(
            child:Text(event.address),
          ),
    ],);
  }

  Widget buttonsRow(Events event, index, List<Events> listEvents, int ind) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewEventDesktop(listEvents[index])),
          );
        },
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
          showAlertDialog(context, event.id, index, ind);
        },
      ).showCursorOnHover,
      SizedBox(width: 15.0,),
    ],);
  }

  showAlertDialog(BuildContext context, int eventId, int index, int ind) {
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: Colors.red),),
      onPressed: () {
        APIServices.removeEvent(TokenSession.getToken, eventId).then((res) {
          if(res.statusCode == 200){
            print("Događaj je uspešno obrisan.");
            setState(() {
              if(ind == 1)
                 events.removeAt(index);
              else
                finishedEvents.removeAt(index);
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
        CenteredViewDonation(
          child: TabBarView(children: <Widget>[
          Column(children: <Widget>[
           Row(children: <Widget>[
           Expanded(child: SizedBox(),),
           RaisedButton(onPressed: () {
             Navigator.push(context, 
               MaterialPageRoute(builder: (context) => CreateEventPage()),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
            child: Row(children: <Widget>[ Text("Dodaj događaj", style: TextStyle(color: Colors.white),), Icon(Icons.add, color: Colors.white,)],),
            color: Color(0xFF00BFA6),
          ).showCursorOnHover,
          ],),
            Flexible(child: buildEventsList(events, 1),),
          ]),
          Column(children: <Widget>[
          Flexible(child: buildEventsList(finishedEvents, 2),)
          ]),
          ],),
          
        ),

        CollapsingNavigationDrawer(),
      ],
    );
  }
}