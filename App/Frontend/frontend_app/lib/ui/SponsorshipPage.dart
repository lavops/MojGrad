import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/events.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/widgets/eventsWidget.dart';

class SponsorshipPage extends StatefulWidget {
  @override
  _SponsorshipPageState createState() => _SponsorshipPageState();
}

class _SponsorshipPageState extends State<SponsorshipPage> {

  static String body = "[{\"eventId\":1,\"eventType\":1},{\"eventId\":2,\"eventType\":2}]";
  static Iterable list = json.decode(body);
  List<Events> events = list.map((model) => Events.fromObject(model)).toList();

  _getEvents() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPost(jwt).then((res) {
      //Menja se u getEvents i mora model da se napravi za eventove i tako to
      if (mounted) {
        setState(() {
          //setuju se eventovi
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //_getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: (events != null)
      ? ListView.builder(
        padding: EdgeInsets.only(bottom: 30.0, top: 30.0),
        itemCount: events == null ? 0 : events.length,
        itemBuilder: (BuildContext context, int index) {
          return EventsWidget(events[index]);
        }
      )
      : Center(
          child: CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.green[800]),
          ),
        )
    );
  }
}