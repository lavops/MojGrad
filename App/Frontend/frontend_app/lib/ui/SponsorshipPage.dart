import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/donation.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/eventWidget.dart';

class SponsorshipPage extends StatefulWidget {
  @override
  _SponsorshipPageState createState() => _SponsorshipPageState();
}

class _SponsorshipPageState extends State<SponsorshipPage> {

  List<Events> events;
  List<Donation> donations;

  _getEvents() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getEvents(jwt,publicUser.id).then((res) {
      Iterable list = json.decode(res.body);
      List<Events> events1 = List<Events>();
      events1 = list.map((model) => Events.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          events = events1;
        });
      }
    });
  }

  _getDonations() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getDonations(jwt).then((res) {
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
    _getEvents();
    _getDonations();
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: EdgeInsets.only(top: 30.0),
            height: 100.0,
            child: tabs(),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: events == null ? 0 : events.length,
              itemBuilder: (BuildContext context, int index) {
                return EventsWidget(events[index]);
              }
            ),
            ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: events == null ? 0 : events.length,
              itemBuilder: (BuildContext context, int index) {
                return EventsWidget(events[index]);
              }
            )
          ],
        ),
      ),
    );
  }

  Widget tabs() {
    return TabBar(
      labelColor: Colors.green,
      indicatorColor: Colors.green,
      unselectedLabelColor: Colors.black,
      tabs: <Widget>[
        Tab(
          child: Text("Događaji"),
        ),
        Tab(
          child: Text("Donacije"),
        ),
      ]);
  }
}

/*
(events != null)
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
*/