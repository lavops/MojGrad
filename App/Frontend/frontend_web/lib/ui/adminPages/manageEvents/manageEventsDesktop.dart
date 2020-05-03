import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewEvent.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:universal_html/html.dart';

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
                  RaisedButton(
                    child: Text("Obriši", style: TextStyle(color: Colors.white),),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
                    onPressed: () {

                    },
                  ),
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
      SizedBox(width: 8.0),
      Text("Počinje: "),
      Text(event.startDate),
      Expanded(child: SizedBox(),),
      Text("Završava se: "),
      Text(event.endDate),
      SizedBox(width: 8.0,),
    ],);
  }

  Widget locationRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 8.0,),
      Icon(Icons.location_on),
      Text(event.address),
    ],);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /*CenteredViewEvent(
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(child: SizedBox(),),
              RaisedButton(
                child: Text("Novi događaj", style: TextStyle(color: Colors.white),),
                color: greenPastel,
                onPressed: () {

                },
                ),
                SizedBox(width: 10.0,),
            ],),
            Flexible(child: buildEventsList(events),),
          ],),
        ),*/
        
        Container(child: ConstrainedBox(child: Column(children: <Widget>[
           Row(children: <Widget>[
           Expanded(child: SizedBox(),),
           RaisedButton(onPressed: () {},
              child: Row(children: <Widget>[ Text("Dodaj dogđaj", style: TextStyle(color: Colors.white),), Icon(Icons.add, color: Colors.white,)],),
              color: greenPastel,
            ),
            ],),
            Flexible(child: buildEventsList(events),),
          ]),
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