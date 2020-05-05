import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../createEventPage.dart';

Color greenPastel = Color(0xFF00BFA6);

class EventPage extends StatefulWidget {
  @override
  _EventPage createState() => _EventPage();
}

class _EventPage extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: IconButton(
                icon: new Icon(Icons.event, color: greenPastel),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateEventPage()),
                  );
                })));
  }
}
