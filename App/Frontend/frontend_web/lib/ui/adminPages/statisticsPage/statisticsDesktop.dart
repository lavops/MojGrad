import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';

class StatisticsDesktop extends StatefulWidget {
  @override
  _StatisticsDesktopState createState() => _StatisticsDesktopState();
}

class _StatisticsDesktopState extends State<StatisticsDesktop> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(children: <Widget>[
      CenteredViewManageUser(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(child: SizedBox()),
              stats("OBJAVE", Icons.photo_library, 5),
              Expanded(child: SizedBox()),
              stats("DOGAĐAJI", Icons.calendar_today, 1),
              Expanded(child: SizedBox()),
              stats("KORISNICI", Icons.account_circle, 5),
              Expanded(child: SizedBox()),
              stats("INSTITUCIJE", Icons.account_balance, 2),
              Expanded(child: SizedBox()),
            ],),
            SizedBox(height: 100,),
            Row(children: <Widget>[
              Expanded(child: SizedBox()),
              newDonation(),
              Expanded(child: SizedBox()),
              eventPost(),
              Expanded(child: SizedBox()),
            ],),
            
          ],
        ),
      ),
      CollapsingNavigationDrawer()
    ]);
  }

  Widget stats(String name, IconData icon, int number){
    return Card(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                  Padding(
                   padding: EdgeInsets.all(8.0),
                      child:Text(name,style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                     child: Row(
                          children: <Widget>[
                            Icon(icon, color:Colors.black, size:80),
                            SizedBox(width: 20),
                            Text("$number", style: TextStyle(color: Colors.grey, fontSize: 40.0)),
                            SizedBox(width: 20),
                          ],
                        ),
                  ),
               ],
              ),
            ],
          ),
        )
    );
  }

  Widget newDonation(){
    return Card(
        child: Column( children: <Widget>[   
        Padding(
          padding: EdgeInsets.all(8.0),
          child:Text("NOVE DONACIJE",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),),
          new Card(
            margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                   SizedBox(width: 5),
                  new Column(
                children: <Widget>[
                      SizedBox(height: 5),
                      Text("PMF Kragujevac",style:TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    
                      Text("Donacija za sadnju drveća",style:TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),

                      Text("Kratak opis koji će se ostaviti nakon ovog okupljanja.",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                     Container(
                      width:400,
                        child:IconRoundedProgressBar(
                          icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.monetization_on)),
                          theme: RoundedProgressBarTheme.green,
                          margin: EdgeInsets.symmetric(vertical: 16),
                          borderRadius: BorderRadius.circular(6),
                          percent: 10,
                          )
                    ),
                    
                      Row(
                          children: <Widget>[
                           new Column(
                              children: <Widget>[
                              Text("Skupljeno:",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                            
                                  Text("30 poena",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),)                
                              ]),
                              SizedBox(width:200),
                             Column(
                              children: <Widget>[
                              Text("Potrebno:",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                             
                                  Text("100 poena",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                  
                          ],)
                          ]),
                      RaisedButton(
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text(
                          "Više informacija",
                          style: TextStyle(fontSize: 13.0),
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        textColor: Colors.black,
                        color: Colors.white,
                        onPressed: () {
                        }
                        ),                   
                        SizedBox(height: 5),
                    ]),
                      
                            ],
                        ),
                  ),
               ],
              ));
  }       

  Widget eventPost(){
    return Card(
        child: Column( children: <Widget>[   
        Padding(
          padding: EdgeInsets.all(8.0),
          child:Text("NOVI DOGAĐAJI",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),),
          new Card(
            margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                   SizedBox(width: 5),
                  new Column(
                children: <Widget>[
                      SizedBox(height: 5),
                      Text("Gradska čistoća",style:TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    
                    Text("Početak:",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),

                      Text("03/06/2020 08:50",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),

                      Text("Čišćenje parka",style:TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),

                      Text("Kratak opis koji će se ostaviti nakon ovog okupljanja.",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                    
                      Text("Ulica Brđanska 48, Kragujevac, Srbija",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),

                      RaisedButton(
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text(
                          "Više informacija",
                          style: TextStyle(fontSize: 13.0),
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        textColor: Colors.black,
                        color: Colors.white,
                        onPressed: () {
                        }
                        ),                   
                        SizedBox(height: 5),
                    ]),
                       SizedBox(width: 20),
                    new Column(
                      children: <Widget>[
                       Row(
                          children: <Widget>[
                            Icon(Icons.location_on,color:Colors.black),
                            Text("Kragujevac",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                         
                          ],
                        ),
 
                      Text("Završetak:",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                    
                      Text("08/06/2020 19:30",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),                   
                    ]),   
                          SizedBox(width: 5),
                        ],
                        ),
                  ),
               ],
              ),
    );
  }       
}