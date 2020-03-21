import 'package:flutter/material.dart';

//import 'edit_profile.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeaderSection();
  }
}

class HeaderSection extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.mode_edit, size: 36),
                  onPressed: () {
                    /*
                    Navigator.push(
                      context,
                      //MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                    */
                  },
                )
              ],
            )
          ])),
          Container(
            child: Icon(Icons.account_circle, size: 110),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "Ime i prezime",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 36),
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "17",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 10),
                    ClipOval(
                      child: Material(
                          color: Colors.green[300],
                          child: InkWell(
                              child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              icon: Icon(
                                Icons.photo,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ))),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(width: 36),
                CustomRow(Icon(Icons.check)),
                SizedBox(width: 36),
                CustomRow(Icon(Icons.star_border)),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class CustomClipOval extends ClipOval {
  Icon _iconn;
  CustomClipOval(Icon iconn) {
    _iconn = iconn;
  }
  get child => Material(
      color: Colors.green[300],
      child: InkWell(
          child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          icon: _iconn,
          onPressed: () {},
        ),
      )));
}

class CustomRow extends Row {
  Icon _iconn;
  CustomRow(Icon iconn) {
    _iconn = iconn;
  }
  get children => [
        Text(
          "10",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 10),
        CustomClipOval(_iconn),
      ];
}
