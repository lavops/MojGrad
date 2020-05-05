import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:frontend_web/extensions/hoverExtension.dart';

import 'models/city.dart';

Color greenPastel = Color(0xFF00BFA6);

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPage createState() => _CreateEventPage();
}

class _CreateEventPage extends State<CreateEventPage> {
  DateTime _startDate;
  DateTime _endDate;
  List<DropdownMenuItem<Time>> _dropdownMenuItems;
  Time _selectedTipStart, _selectedTipEnd;
  List<Time> times = Time.getTimes();
  List<City> listCities;
  City city;

  TextEditingController nameController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String wrongText = "";
  String startDate = "";
  String endDate = "";

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: DateTime.now(),
        initialLastDate: DateTime.now(),
        firstDate: new DateTime(DateTime.now().year - 5),
        lastDate: new DateTime(DateTime.now().year + 10));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
      });
    }
  }

  _getCities() {
    APIServices.getCity(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<City> listC = List<City>();
      listC = list.map((model) => City.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listCities = listC;
        });
      }
    });
  }

  List<DropdownMenuItem<Time>> buildDropDownMenuItems(List tips) {
    List<DropdownMenuItem<Time>> items = List();
    for (Time tip in tips) {
      items.add(DropdownMenuItem(
        value: tip,
        child: Text(tip.toString()),
      ));
    }
    return items;
  }

  onChangedDropdownItemStart(Time selectedTip) {
    setState(() {
      _selectedTipStart = selectedTip;
    });
  }

  onChangedDropdownItemEnd(Time selectedTip) {
    setState(() {
      _selectedTipEnd = selectedTip;
    });
  }

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(times);
    _selectedTipStart = _dropdownMenuItems[0].value;
    _selectedTipEnd = _dropdownMenuItems[0].value;
    _getCities();
  }

  Widget locationWidget() {
    return Container(
      width: 500,
      child: TextField(
        cursorColor: Colors.black,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        controller: locationController,
        decoration: InputDecoration(
          hintText: "Lokacija",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.location_on, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget nameEvent() {
    return Container(
      width: 500,
      child: TextField(
        cursorColor: Colors.black,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        controller: nameController,
        decoration: InputDecoration(
          hintText: "Ime događaja",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget shortDescription() {
    return Container(
      width: 500,
      child: TextField(
        cursorColor: Colors.black,
        controller: shortDescriptionController,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Kratak opis",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget longDescription() {
    return Container(
      width: 500,
      child: TextFormField(
        maxLines: 5,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: "Opis događaja",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget calendar() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _startDate == null && _endDate == null
                ? Text('Izaberi datum', style: TextStyle(fontSize: 16))
                : Text(''),
            IconButton(
              icon: Icon(Icons.calendar_today, size: 26, color: greenPastel),
              onPressed: () async {
                await displayDateRangePicker(context);
              },
            ),
          ],
        ),
        SizedBox(width: 5),
        _startDate != null && _endDate != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(''),
                  Text(
                    "Datum početka: ${DateFormat('MM/dd/yyyy').format(_startDate).toString()}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                      "Datum završetka: ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}",
                      style: TextStyle(fontSize: 16)),
                ],
              )
            : Text('')
      ],
    ).showCursorOnHover;
  }

  Widget dropdownTime(List<Time> times) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 50, right: 10, top: 20, bottom: 10),
            ),
            Text('Vreme početka', style: TextStyle(fontSize: 16)),
            Container(
                width: 100,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  value: _selectedTipStart,
                  items: _dropdownMenuItems,
                  onChanged: onChangedDropdownItemStart,
                ))
          ],
        ),
        SizedBox(width: 50),
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 50, right: 10, top: 20, bottom: 10),
            ),
            Text('Vreme završetka', style: TextStyle(fontSize: 16)),
            Container(
                width: 100,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  value: _selectedTipEnd,
                  items: _dropdownMenuItems,
                  onChanged: onChangedDropdownItemEnd,
                ))
          ],
        )
      ],
    ).showCursorOnHover;
  }

  Widget dropdownCity(List<City> listCities) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 50, right: 10, top: 20, bottom: 10),
          ),
          Text("Izaberite grad: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Container(
            padding: EdgeInsets.all(5.0),
          ),
          listCities != null
              ? new DropdownButton<City>(
                  hint: Text("Izaberi"),
                  value: city,
                  onChanged: (City newValue) {
                    setState(() {
                      city = newValue;
                    });
                  },
                  items: listCities.map((City option) {
                    return DropdownMenuItem(
                      child: new Text(option.name),
                      value: option,
                    );
                  }).toList(),
                )
              : new DropdownButton<String>(
                  hint: Text("Izaberi"),
                  onChanged: null,
                  items: null,
                ),
        ]).showCursorOnHover;
  }

  Widget wrong() {
    return Container(
        child: Center(
            child: Text(
      '$wrongText',
      style: TextStyle(color: Colors.red),
    )));
  }

  Widget createEventButton() {
    return RaisedButton(
      onPressed: () {
        
        //print(_startDateString + ' ' + _selectedTipStart.toString());
        // print(_endDateString + ' ' + _selectedTipEnd.toString());

        var str = TokenSession.getToken;
        var jwt = str.split(".");
        var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        print(payload);

        if (nameController.text != '' &&
            locationController.text != '' &&
            _startDate != null &&
            _endDate != null) {

          String _startDateString = DateFormat.yMd().format(_startDate);
          String _endDateString = DateFormat.yMd().format(_endDate);

          startDate = _startDateString + ' ' + _selectedTipStart.toString();
          endDate = _endDateString + ' ' + _selectedTipEnd.toString();

          APIServices.createEvent(
              str,
              int.parse(payload["sub"]),
              nameController.toString(),
              shortDescriptionController.toString(),
              descriptionController.toString(),
              locationController.toString(),
              city.name,
              startDate,
              endDate);

          print('nisu dobri podaci');
          setState(() {
            wrongText = "";
          });
        } else {
          setState(() {
            wrongText = "Unesite sve podatke!";
          });
        }
      },
      color: greenPastel,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: greenPastel)),
      child: Text("Kreiraj", style: TextStyle(color: Colors.white)),
    ).showCursorOnHover;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SingleChildScrollView(
          child: Material(
              elevation: 5,
              child: Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment(-0.75, -0.75),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: greenPastel,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: greenPastel)),
                          child: Text(
                            "Vrati se nazad",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ).showCursorOnHover,
                      nameEvent(),
                      Container(
                        margin: EdgeInsets.only(
                            left: 50, right: 20, top: 10, bottom: 10),
                      ),
                      shortDescription(),
                      Container(
                        margin: EdgeInsets.only(
                            left: 50, right: 20, top: 10, bottom: 10),
                      ),
                      longDescription(),
                      Container(
                        margin: EdgeInsets.only(
                            left: 50, right: 20, top: 10, bottom: 10),
                      ),
                      locationWidget(),
                      Container(
                        margin: EdgeInsets.only(
                            left: 50, right: 20, top: 10, bottom: 10),
                      ),
                      calendar(),
                      dropdownCity(listCities),
                      dropdownTime(times),
                      Container(
                        margin: EdgeInsets.only(
                            left: 50, right: 20, top: 10, bottom: 10),
                      ),
                      createEventButton(),
                      wrong()
                    ],
                  )))),
      CollapsingNavigationDrawer()
    ]);
  }
}

class Time {
  int id;
  TimeOfDay time;

  Time(this.id, this.time);

  @override
  String toString() {
    String hour =
        time.hour < 10 ? "0" + time.hour.toString() : time.hour.toString();
    String minute = time.minute == 0
        ? "0" + time.minute.toString()
        : time.minute.toString();

    return hour + ":" + minute;
  }

  static List<Time> getTimes() {
    return <Time>[
      Time(1, TimeOfDay(hour: 00, minute: 00)),
      Time(2, TimeOfDay(hour: 00, minute: 15)),
      Time(3, TimeOfDay(hour: 00, minute: 30)),
      Time(4, TimeOfDay(hour: 00, minute: 45)),
      Time(5, TimeOfDay(hour: 01, minute: 00)),
      Time(6, TimeOfDay(hour: 01, minute: 15)),
      Time(7, TimeOfDay(hour: 01, minute: 30)),
      Time(8, TimeOfDay(hour: 01, minute: 45)),
      Time(9, TimeOfDay(hour: 02, minute: 00)),
      Time(10, TimeOfDay(hour: 02, minute: 15)),
      Time(11, TimeOfDay(hour: 02, minute: 30)),
      Time(12, TimeOfDay(hour: 02, minute: 45)),
      Time(13, TimeOfDay(hour: 03, minute: 00)),
      Time(14, TimeOfDay(hour: 03, minute: 15)),
      Time(15, TimeOfDay(hour: 03, minute: 30)),
      Time(16, TimeOfDay(hour: 04, minute: 00)),
      Time(17, TimeOfDay(hour: 04, minute: 15)),
      Time(18, TimeOfDay(hour: 04, minute: 30)),
      Time(19, TimeOfDay(hour: 04, minute: 45)),
      Time(20, TimeOfDay(hour: 04, minute: 00)),
      Time(21, TimeOfDay(hour: 04, minute: 15)),
      Time(22, TimeOfDay(hour: 04, minute: 30)),
      Time(23, TimeOfDay(hour: 04, minute: 45)),
      Time(24, TimeOfDay(hour: 05, minute: 00)),
      Time(25, TimeOfDay(hour: 05, minute: 15)),
      Time(26, TimeOfDay(hour: 05, minute: 30)),
      Time(27, TimeOfDay(hour: 05, minute: 45)),
      Time(28, TimeOfDay(hour: 06, minute: 00)),
      Time(29, TimeOfDay(hour: 06, minute: 15)),
      Time(30, TimeOfDay(hour: 06, minute: 30)),
      Time(31, TimeOfDay(hour: 06, minute: 45)),
      Time(32, TimeOfDay(hour: 07, minute: 00)),
      Time(33, TimeOfDay(hour: 07, minute: 15)),
      Time(34, TimeOfDay(hour: 07, minute: 30)),
      Time(35, TimeOfDay(hour: 07, minute: 45)),
      Time(36, TimeOfDay(hour: 08, minute: 00)),
      Time(37, TimeOfDay(hour: 08, minute: 15)),
      Time(38, TimeOfDay(hour: 08, minute: 30)),
      Time(39, TimeOfDay(hour: 08, minute: 45)),
      Time(40, TimeOfDay(hour: 09, minute: 00)),
      Time(41, TimeOfDay(hour: 09, minute: 15)),
      Time(42, TimeOfDay(hour: 09, minute: 30)),
      Time(43, TimeOfDay(hour: 09, minute: 45)),
      Time(44, TimeOfDay(hour: 10, minute: 00)),
      Time(45, TimeOfDay(hour: 10, minute: 15)),
      Time(46, TimeOfDay(hour: 10, minute: 30)),
      Time(47, TimeOfDay(hour: 10, minute: 45)),
      Time(48, TimeOfDay(hour: 11, minute: 00)),
      Time(49, TimeOfDay(hour: 11, minute: 15)),
      Time(50, TimeOfDay(hour: 11, minute: 30)),
      Time(51, TimeOfDay(hour: 11, minute: 45)),
      Time(52, TimeOfDay(hour: 12, minute: 00)),
      Time(53, TimeOfDay(hour: 12, minute: 15)),
      Time(54, TimeOfDay(hour: 12, minute: 30)),
      Time(55, TimeOfDay(hour: 12, minute: 45)),
      Time(56, TimeOfDay(hour: 13, minute: 00)),
      Time(57, TimeOfDay(hour: 13, minute: 15)),
      Time(58, TimeOfDay(hour: 13, minute: 30)),
      Time(59, TimeOfDay(hour: 13, minute: 45)),
      Time(60, TimeOfDay(hour: 14, minute: 00)),
      Time(61, TimeOfDay(hour: 14, minute: 15)),
      Time(62, TimeOfDay(hour: 14, minute: 30)),
      Time(63, TimeOfDay(hour: 14, minute: 45)),
      Time(64, TimeOfDay(hour: 15, minute: 00)),
      Time(65, TimeOfDay(hour: 15, minute: 15)),
      Time(66, TimeOfDay(hour: 15, minute: 30)),
      Time(67, TimeOfDay(hour: 15, minute: 45)),
      Time(68, TimeOfDay(hour: 16, minute: 00)),
      Time(69, TimeOfDay(hour: 16, minute: 15)),
      Time(70, TimeOfDay(hour: 16, minute: 30)),
      Time(71, TimeOfDay(hour: 16, minute: 45)),
      Time(72, TimeOfDay(hour: 17, minute: 00)),
      Time(73, TimeOfDay(hour: 17, minute: 15)),
      Time(74, TimeOfDay(hour: 17, minute: 30)),
      Time(75, TimeOfDay(hour: 17, minute: 45)),
      Time(76, TimeOfDay(hour: 18, minute: 00)),
      Time(77, TimeOfDay(hour: 18, minute: 15)),
      Time(78, TimeOfDay(hour: 18, minute: 30)),
      Time(79, TimeOfDay(hour: 18, minute: 45)),
      Time(80, TimeOfDay(hour: 19, minute: 00)),
      Time(81, TimeOfDay(hour: 19, minute: 15)),
      Time(82, TimeOfDay(hour: 19, minute: 30)),
      Time(83, TimeOfDay(hour: 19, minute: 45)),
      Time(84, TimeOfDay(hour: 20, minute: 00)),
      Time(85, TimeOfDay(hour: 20, minute: 15)),
      Time(86, TimeOfDay(hour: 20, minute: 30)),
      Time(87, TimeOfDay(hour: 20, minute: 45)),
      Time(88, TimeOfDay(hour: 21, minute: 00)),
      Time(89, TimeOfDay(hour: 21, minute: 15)),
      Time(90, TimeOfDay(hour: 21, minute: 30)),
      Time(91, TimeOfDay(hour: 21, minute: 45)),
      Time(92, TimeOfDay(hour: 22, minute: 00)),
      Time(93, TimeOfDay(hour: 22, minute: 15)),
      Time(94, TimeOfDay(hour: 22, minute: 30)),
      Time(95, TimeOfDay(hour: 22, minute: 45)),
      Time(96, TimeOfDay(hour: 23, minute: 00)),
      Time(97, TimeOfDay(hour: 23, minute: 15)),
      Time(98, TimeOfDay(hour: 23, minute: 30)),
      Time(99, TimeOfDay(hour: 23, minute: 45)),
    ];
  }
}
