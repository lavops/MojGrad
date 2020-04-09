import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/ui/postPage.dart';
import 'package:frontend_web/ui/registerAdminPage.dart';
import './navDrawer.dart';
import 'package:frontend_web/ui/usersProfilePage.dart';


class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class SalesData {
  SalesData(this.month, this.number);

  final String month;
  final int number;
}

class _StatisticsPageState extends State<StatisticsPage> {
 var data = [2.0,0.0,3.0,1.0,2.0,2.0,4.0];
  var data1 = [0.0,-2.0,3.5,-2.0,0.5,0.7,0.8,1.0,2.0,3.0,3.2];

  List<CircularStackEntry> circularData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(6.0, Color(0xff4285F4), rankKey: 'Rešeno'),
        new CircularSegmentEntry(4.0, Color(0xff40b24b), rankKey: 'Nerešeno'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];

  Material myTextItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Center(
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
                      child:Text(title,style:TextStyle(
                        fontSize: 20.0,
                        color: Colors.green,
                      ),),
                    ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

               ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material myCircularItems(String title){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Center(
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
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                    ),),
                  ),

                  Padding(
                    padding:EdgeInsets.all(8.0),
                    child:AnimatedCircularChart(
                      size: const Size(160.0, 160.0),
                      initialChartData: circularData,
                      chartType: CircularChartType.Pie,
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


  Material mychart1Items(String title, String newVal) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(20.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(newVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Container(
      color: Colors.grey[200],
      height: 200,
      width: 400,
      child: BezierChart(
        bezierChartScale: BezierChartScale.CUSTOM,
        xAxisCustomValues: const [0, 5, 10, 15, 20, 25, 30, 35],
        series: const [
          BezierLine(
            lineColor: Colors.black26,
            dataPointStrokeColor : Colors.black26 ,
            dataPointFillColor : Colors.black26,
            data: const [
              DataPoint<double>(value: 10, xAxis: 0),
              DataPoint<double>(value: 5, xAxis: 5),
              DataPoint<double>(value: 8, xAxis: 10),
              DataPoint<double>(value: 12, xAxis: 15),
              DataPoint<double>(value: 3, xAxis: 20),
              DataPoint<double>(value: 0, xAxis: 25),
              DataPoint<double>(value: 10, xAxis: 30),
              DataPoint<double>(value: 12, xAxis: 35),
            ],
          ),
        ],
        config: BezierChartConfig(
          xLinesColor: Colors.black26,
          verticalIndicatorStrokeWidth: 4.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          backgroundColor: Colors.grey,
          snap: false,
        ),
      ),
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


  Material mychart2Items(String title, String priceVal) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Sparkline(
                      data: data,
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

  @override
  Widget build(BuildContext context) {
    double width1 = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
           Navigator.pop(context);
        }),
        title: Text("Statistički podaci"),
        actions: <Widget>[
          IconButton(icon: Icon(
              FontAwesomeIcons.chartLine), onPressed: () {
            //
          }),
        ],
      ),
      body:Center(
        child: Container(
         // width: width1,
          color:Color(0xffE5E5E5),
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
          child:StaggeredGridView.count(
            crossAxisCount: 4,
           crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: mychart1Items("Mesečne registracije","10"),
          ), 
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: mychart2Items ("Prijave za ovu nedelju", "10"),
          ),
           Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: myTextItems("Broj korisnika","10"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: myCircularItems("Rešeni i nerešeni"),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: myTextItems("Broj objava","15"),
          ),
          

        ],
        staggeredTiles: [
          StaggeredTile.extent(3, 300.0),
          StaggeredTile.extent(1, 600.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 300.0),
          StaggeredTile.extent(1, 150.0),
        ],
      ),
      ),
    ),);
  }
}