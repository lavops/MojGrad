import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeaderSection();
  }
}

class HeaderSection extends State<UserProfilePage> {
  final Color green = Color(0xFF1E8161);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
          elevation: 0,
          backgroundColor: green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {}, //dodati
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {}, //edit profile
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 3, bottom: 16),
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Column(
                children: <Widget>[
                  Icon(Icons.account_circle, color: Colors.white, size: 110),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "korisnicko ime",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Ime i prezime',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "17",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: <Widget>[
                              Icon(Icons.image, color: Colors.white, size: 36),
                              Text(
                                'Objave',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(width: 56),
                          Row(
                            children: <Widget>[
                              Text(
                                "77",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: <Widget>[
                              Icon(Icons.check, color: Colors.white, size: 36),
                              Text(
                                'Poeni',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(width: 56),
                          Row(
                            children: <Widget>[
                              Text(
                                "7",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: <Widget>[
                              Icon(Icons.star_border,
                                  color: Colors.white, size: 36),
                              Text(
                                'Nivo',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
