import 'package:flutter/material.dart';
import 'package:frontend_web/ui/InstitutionPages/loginPage/loginPage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class HomeNavigationBar extends StatelessWidget{
  final int selected;
  HomeNavigationBar(this.selected);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: HomeNavigationBarTabletDesktop(selected),
      mobile: HomeNavigationBarMobile(selected),
      tablet: HomeNavigationBarTabletDesktop(selected),
    );
  }
}

class HomeNavigationBarMobile extends StatelessWidget{
  final int selected;
  HomeNavigationBarMobile(this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: SizedBox(
              width: 200,
              child: Image.asset('assets/mojGrad4.png'),
            ),
            onTap: (){
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView()
                    )
                  );
            },
          ),
          new Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.toc),
              onPressed: (){
                Scaffold.of(context).openDrawer(); 
                print('Nece da pull endDrawer');
              },
            );
          })
          
        ],
      ),
    );
  }
}

class HomeNavigationBarTabletDesktop extends StatelessWidget{
  final int selected;
  HomeNavigationBarTabletDesktop(this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: SizedBox(
              width: 200,
              child: Image.asset('assets/mojGrad2.png'),
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView()
                )
              );
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                child: Text( "Prijavi se", 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: (selected == 1)? greenPastel : Colors.black,
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstitutionLoginPage()
                    )
                  );
                },
              ),
              SizedBox(width: 10,),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeNavigationDrawer extends StatelessWidget{
  final int selected;
  HomeNavigationDrawer(this.selected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Container(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(child: Text("MOJ GRAD"),),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text(
                'Institucija',
                style: TextStyle(fontSize: 16, color: (selected == 1)? greenPastel : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstitutionLoginPage()
                    )
                  );
              },
            ),
          ],
        ),
      )
    );
  }
}