import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/CameraPage.dart';
import 'package:frontend/ui/NavDrawer.dart';
import 'package:frontend/ui/SponsorshipPage.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/ui/commentsPage.dart';


class MyBottomBar extends StatefulWidget {
  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _currentIndex=0;
  final List<Widget> _pages=[
    HomePage(),
    HomePage(),
    CameraPage(),
    SponsorshipPage(),
    
  ];

  void onTappedBar(int index)
  {
    if(mounted){
    setState(() {
      _currentIndex=index;
    });
    }
    else 
      _currentIndex=0;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:_pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items:[
          BottomNavigationBarItem(
            icon:new Icon(Icons.home),
            title: Text("Početna strana"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon:new Icon(Icons.check),
            title: Text("Rešeno"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon:new Icon(Icons.camera),
            title: Text("Kamera"),
            backgroundColor: Colors.white,
          ),

          BottomNavigationBarItem(
            icon:new Icon(Icons.attach_money),
            title: Text("Sponzorstvo"),
            backgroundColor: Colors.white,
          ),
         
        ],
         onTap: onTappedBar,
        selectedItemColor: Colors.green[800],
        
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<FullPost> listPosts;
  getPosts() {
    APIServices.getPost().then((res) {  
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if(mounted){
      setState(() {
        listPosts = listP;
      
      });
      }
    });
  }

   Widget buildPostList() {
    getPosts();
    return ListView.builder( 
      itemCount: listPosts == null ? 0 : listPosts.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
         padding: EdgeInsets.all(10),
         // margin: EdgeInsets.all(10),
         decoration: BoxDecoration(
         border: Border(
             bottom: BorderSide(color: Colors.grey)
           ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[ 
                  IconButton(
                    
                    icon: Icon(Icons.account_circle, color: Colors.black, size: 30),
                    onPressed: () {
                        
                      },
                    ),
                   Text(listPosts[index].username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                   SizedBox(width: 200,),
                    IconButton(
                    padding: EdgeInsets.all(5.0),
                    icon: Icon(Icons.more_horiz, color: Colors.black, size: 30),
                    onPressed: () {
                      },
                    ),

                 ],
                 )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(5.0),
                    icon: Icon(Icons.feedback, color: Colors.red, size: 30),
                    onPressed: () {
                      },
                    ),
                  SizedBox(width: 80,),
                  Text("Kategorija problema: "+listPosts[index].typeName, style: TextStyle(fontSize: 15),),
                 ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width / 0.5,
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ), 
                  child: Text(
                    listPosts[index].description,
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
               ),

              Align(
                alignment: Alignment.center,
                child: Container(
                child: Image.asset("assets/post1.jpg",width: 400,height: 350, ),
                 ),
               ),
             
              Container(
                decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                  bottom: BorderSide(color: Colors.grey)
                    ),
                  ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 2,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(11.0),
                      side: BorderSide(color: Colors.green)
                    ),
                    color: Colors.green,
                    child: Text("Reši"),
                    onPressed: () {

                    },
                  ),
                
                  SizedBox(width: 30,),
                  IconButton(
                      icon: Icon(Icons.arrow_upward,color: Colors.green,  size: 30),
                      onPressed: () {
                        APIServices.addLike(listPosts[index].postId, 1, 2);
                      },
                    ),
                  Text(listPosts[index].likeNum.toString()),
                  IconButton(
                      icon: Icon(Icons.arrow_downward,color: Colors.red,  size: 30),
                      onPressed: () {
                        
                        APIServices.addLike(listPosts[index].postId, 1, 1);
                      },
                    ),
                  Text(listPosts[index].dislikeNum.toString()),
                  IconButton(
                      icon: Icon(Icons.comment,color: Colors.black,  size: 30),
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentsPage(listPosts[index].postId)),
                        );
                      },
                    ),
                  Text(listPosts[index].commNum.toString()),
                  SizedBox(width: 5,)
                ],

              ),
              ),
               SizedBox(height: 20,)
             ],
           ),
        );
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavDrawer(),
      appBar: new AppBar(    
        backgroundColor: Colors.white,
        leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.menu),
                color: Colors.black87,
                onPressed: () {
                 // Navigator.push(
                 //   context,
                 //   MaterialPageRoute(builder: (context) => NavDrawer()),
                 // );
                },
              );
            }),
        title: Text(
          "MOJ GRAD",
          style: TextStyle(
            color: Colors.green,
            fontSize: 22.0,
            fontFamily: 'pirulen rg',
          ),
          
        ),
        actions: <Widget>[
        // action button
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black87,
            onPressed: () {

          },
        ),
        // action button
         
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black87,
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(Icons.person), 
            color: Colors.black87,
            onPressed: () {
              
            },
          ),
       ],
      ),


      body: buildPostList() ,
    );
  }
}