import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:latlong/latlong.dart';

class EventsWidget extends StatefulWidget {
  final Events event;

  EventsWidget(this.event);

  @override
  _EventsWidgetState createState() => _EventsWidgetState(event);
}

class _EventsWidgetState extends State<EventsWidget> {
  Events event;
  List<User> users;
  TextEditingController donateController = new TextEditingController();

  _EventsWidgetState(Events event1) {
    this.event = event1;
  }

  @override
  Widget build(BuildContext context) {
    return buildEvent();
  }

  Widget buildEvent() => Card(
          child: Column(children: <Widget>[
        eventInfoRow(),
        startEndDate(),
        SizedBox(
          height: 10.0,
        ),
        titleRow(),
        descriptionRow(),
        SizedBox(
          height: 10.0,
        ),
        actionButtonRow()
      ]));

  Widget eventInfoRow() {
    return Row(children: <Widget>[
      SizedBox(
        width: 10.0,
      ),
      Text(event.organizeName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
      Expanded(child: SizedBox()),
      Icon(Icons.location_on),
      Text(event.cityName),
      SizedBox(
        width: 10.0,
      ),
    ]);
  }

  Widget startEndDate() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        Column(
          children: <Widget>[Text("Datum pocetka:"), Text(event.startDate)],
        ),
        Expanded(child: SizedBox()),
        Column(
          children: <Widget>[Text("Datum završetka:"), Text(event.endDate)],
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget titleRow() {
    return Container(
        child: Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        Flexible(
            child: Text(event.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
        SizedBox(
          width: 10.0,
        ),
      ],
    ));
  }

  Widget descriptionRow() {
    return Container(
        child: Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        (event.shortDescription != null)
            ? Flexible(child: Text(event.shortDescription))
            : Text("Nema kratak opis."),
        SizedBox(
          width: 10.0,
        ),
      ],
    ));
  }

  Widget actionButtonRow() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventsPageWidget(event)),
            );
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green[800])),
          child: Text("Više informacija"),
        ),
        Expanded(child: SizedBox()),
        (event.isGoing != 1)
            ? RaisedButton(
                onPressed: () {
                  joinEventActionButton();
                },
                color: Colors.green[800],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green[800])),
                child:
                    Text("Pridruži se", style: TextStyle(color: Colors.white)),
              )
            : RaisedButton(
                onPressed: () {
                  leaveEventActionButton();
                },
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                child: Text("Otkaži dolazak",
                    style: TextStyle(color: Colors.white)),
              ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  joinEventActionButton() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Pridruži se događaju!", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 18)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Pridruži se",
                style: TextStyle(color: Colors.green[800]),
              ),
              onPressed: () {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.joinEvent(jwt, event.id, userId).then((res) {
                      if (res.statusCode == 200) {
                        print('Uspesno ste sepridruzili dogadjaju.');
                        setState(() {
                          event.isGoing = 1;
                        });
                      }
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Otkaži",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  leaveEventActionButton() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Otkaži prisustvo događaju!", style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyText1.color)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Potvrdi",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.joinEvent(jwt, event.id, userId).then((res) {
                      if (res.statusCode == 200) {
                        print('Uspesno ste napustili dogadjaj.');
                        setState(() {
                          event.isGoing = 0;
                        });
                      }
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Otkaži",
                style: TextStyle(color: Colors.green[800]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  showUsers() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Otkaži prisustvo događaju!"),
          content: Container(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 30.0),
                itemCount: users == null ? 0 : users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(child: Text(users[index].username));
                }),
          ),
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
                "Otkaži",
                style: TextStyle(color: Colors.green[800]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}

class EventsPageWidget extends StatefulWidget {
  final Events event;

  EventsPageWidget(this.event);

  @override
  _EventsPageWidgetState createState() => _EventsPageWidgetState(event);
}

class _EventsPageWidgetState extends State<EventsPageWidget> {
  Events event;
  List<User> users;
  TextEditingController donateController = new TextEditingController();

  _EventsPageWidgetState(Events event1) {
    this.event = event1;
  }

  _getUsersFromEvent() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getUsersFromEvent(jwt, event.id).then((res) {
      Iterable list = json.decode(res);
      List<User> users1 = List<User>();
      users1 = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          users = users1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsersFromEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).copyWith().backgroundColor,
          iconTheme: IconThemeData(
              color: Theme.of(context).copyWith().iconTheme.color),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(event.organizeName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0)),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Datum početka:"),
                    Text(event.startDate)
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    Text("Datum završetka:"),
                    Text(event.endDate)
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            showMap(),
            SizedBox(
              height: 20.0,
            ),
            Flexible(child: Text(event.address)),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
                child: Text(event.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0))),
            SizedBox(
              height: 10.0,
            ),
            Flexible(child: Text(event.description)),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Text("Učesnici:"),
                Expanded(child: SizedBox()),
                Text("${event.userNum}" == '1'
                    ? "${event.userNum} korisnik"
                    : "${event.userNum} korisnika"),
              ],
            ),
            (users != null) ? listUsers() : SizedBox(),
          ]),
        ));
  }

  Widget showMap() {
    return Container(
        height: 200,
        width: double.infinity,
        child: FlutterMap(
          options: new MapOptions(
            center: new LatLng(event.latitude,
                event.longitude), //event.latitude, event.longitude
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
            new MarkerLayerOptions(markers: [
              Marker(
                point: new LatLng(event.latitude,
                    event.longitude), //event.latitude, event.longitude
                builder: (ctx) => new Container(
                    child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                )),
              ),
            ]),
          ],
        ));
  }

  Widget listUsers() {
    return Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          direction: Axis.horizontal,
          children: users
              .map((User user) => InputChip(
                    avatar: CircleAvatar(
                      child: Container(
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      serverURLPhoto + user.photo)))),
                    ),
                    label: Text(user.firstName + " " + user.lastName),
                    onPressed: () {
                      if (user.id != userId)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OthersProfilePage(user.id)),
                        );
                    },
                  ))
              .toList(),
        ));
  }
}
