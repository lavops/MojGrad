import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/models/statistics.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';

class StatisticsTablet extends StatefulWidget {
  @override
  _StatisticsTabletState createState() => _StatisticsTabletState();
}

class _StatisticsTabletState extends State<StatisticsTablet> {
  List<User> listUsers;
  Statistics stat;
  List<double> monthlyUsers;
  Donation donation;

  _getUsers() {
    APIServices.getTop10(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUsers = listU;
        });
      }
    });
  }

  _getMonthlyUsers() {
    APIServices.getMonthlyUsers(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<double> listU = List<double>();
      listU = list.cast<double>();
      if (mounted) {
        setState(() {
          monthlyUsers = listU;
        });
      }
    });
  }

  _getStatistics() async {
    var res = await APIServices.getStatistics(TokenSession.getToken);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Statistics statistics = Statistics.fromObject(jsonUser);
    setState(() {
      stat = statistics;
    });
  }

  _getDonation() async {
    var res = await APIServices.getLastDonation(TokenSession.getToken);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Donation don = Donation.fromObject(jsonUser);
    setState(() {
      donation = don;
    });
  }

  void initState() {
    super.initState();
    _getUsers();
    _getStatistics();
    _getMonthlyUsers();
    _getDonation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: (stat != null && donation != null && monthlyUsers != null)
          ? Stack(children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            stats("OBJAVE", Icons.photo_library,
                                stat.numberOfPosts, stat.numberOfNewPostsIn24h),
                            Expanded(child: SizedBox(width: 5)),
                            stats("KORISNICI", Icons.account_circle,
                                stat.numberOfUsers, stat.numberOfNewUsersIn24h),
                            Expanded(child: SizedBox(width: 5)),
                            stats(
                                "INSTITUCIJE",
                                Icons.account_balance,
                                stat.numberOfInstitutions,
                                stat.numberOfNewInstitutionIn24h),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: SizedBox(width: 5)),
                            stats("DOGAĐAJI", Icons.calendar_today,
                                stat.numberOfEvents, stat.numberOfActiveEvents),
                            Expanded(child: SizedBox(width: 5)),
                            stats(
                                "DONACIJE",
                                Icons.calendar_today,
                                stat.numberOfDonations,
                                stat.numberOfActiveDonations),
                            Expanded(child: SizedBox(width: 5)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildUserList(listUsers),
                        SizedBox(
                          height: 20,
                        ),
                        newDonation(),
                        SizedBox(
                          height: 20,
                        ),
                        eventPost(),
                      ],
                    ),
                  )),
              CollapsingNavigationDrawer()
            ])
          : Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenPastel),
              ),
            ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 4));
    setState(() {
      stat = new Statistics();
      donation = new Donation();
    });
    _getStatistics();
    _getDonation();
    _getMonthlyUsers();
    return null;
  }

  Widget stats(String name, IconData icon, int number, int number2) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(icon, color: Colors.black, size: 40),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text("$number",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0)),
                        Text("+ " + "$number2",
                            style: TextStyle(
                                color: Colors.lightGreen, fontSize: 20.0)),
                      ],
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget newDonation() {
    return Card(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "POSLEDNJA DONACIJA",
            style: TextStyle(fontSize: 15.0, color: Colors.grey),
          ),
        ),
        new Card(
          margin: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 5),
              new Column(children: <Widget>[
                SizedBox(height: 5),
                Text(
                  donation.organizationName,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  donation.title,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                    width: 400,
                    child: IconRoundedProgressBar(
                      icon: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.monetization_on)),
                      theme: RoundedProgressBarTheme.green,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      borderRadius: BorderRadius.circular(6),
                      percent:
                          (donation.pointsAccumulated / donation.pointsNeeded) *
                              22,
                    )),
                Row(children: <Widget>[
                  new Column(children: <Widget>[
                    Text(
                      "Skupljeno:",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      donation.pointsAccumulated.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    )
                  ]),
                  SizedBox(width: 200),
                  Column(
                    children: <Widget>[
                      Text(
                        "Potrebno:",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        donation.pointsNeeded.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ]),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      "Više informacija",
                      style: TextStyle(fontSize: 13.0),
                    ),
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    textColor: Colors.black,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewDonationPage(donation)),
                      );
                    }),
                SizedBox(height: 5),
              ]),
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildUserList(List<User> listUsers) {
    return Card(
        child: Column(
      children: [
        Text("Top 10 najboljih korisnika"),
        Container(
            width: 350,
            height: 265,
            child: ListView.builder(
              itemCount: listUsers == null ? 0 : listUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 5),
                          child: Row(children: [
                            CircleImage(
                              userPhotoURL + listUsers[index].photo,
                              imageSize: 40.0,
                              whiteMargin: 2.0,
                              imageMargin: 6.0,
                            ),
                            Container(
                              // width: 80,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(listUsers[index].username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      listUsers[index].firstName +
                                          " " +
                                          listUsers[index].lastName,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15))
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 10,
                            )),
                            Text(
                              (listUsers[index].points +
                                      listUsers[index].donatedPoints)
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                          ])),
                    ],
                  ),
                ));
              },
            ))
      ],
    ));
  }

  Widget eventPost() {
    return Card(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Novi korisnici u prethodnih mesec dana",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Sparkline(
                      fallbackWidth: 200,
                      data: monthlyUsers,
                      lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.all,
                      pointSize: 8.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
