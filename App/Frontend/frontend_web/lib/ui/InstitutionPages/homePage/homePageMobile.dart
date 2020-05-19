import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/postType.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostMobile.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../widgets/circleImageWidget.dart';
import '../solvePage/solvePage.dart';
import 'viewProfile/viewProfilePageIns.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';


List<int> listSelectedTypes = new List();
int indikator = 0;



class HomeInstitutionMobile extends StatefulWidget {
  @override
  _HomeInstitutionMobileState createState() => _HomeInstitutionMobileState();
}

class _HomeInstitutionMobileState extends State<HomeInstitutionMobile> {
  List<FullPost> listUnsolvedPosts;
  Institution institution;
  List<FullPost> listFilteredPosts;
  List<PostType> listTypes;
  int _currentImageIndex = 0;


  _getUnsolvedPosts() async  {

    var res = await APIServices.getInstitutionById(TokenSession.getToken, insId);
    Map<String, dynamic> jsonInst = jsonDecode(res.body);
    Institution inst = Institution.fromObject(jsonInst);
    setState(() {
      institution = inst;
      icityId = institution.cityId;
    });

    res =  await APIServices.getInstitutionUnsolvedFromCityId(TokenSession.getToken, icityId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnsolvedPosts = listP;
        });
      }
    });
  }

  _getFiltered(int cid) async {

    await APIServices.getFiltered(TokenSession.getToken, listSelectedTypes, cid).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> posts =  List<FullPost>();
      posts = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listFilteredPosts = posts;
        });
      }
    });
  }


  _getPostType() async {
    var res =  await APIServices.getPostType(TokenSession.getToken);
    Iterable list = json.decode(res.body);
    List<PostType> postTypes = new List<PostType>();
    postTypes = list.map((model) => PostType.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listTypes = postTypes;
      });
    }
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: listTypes == null ? 0 : listTypes.length,
        itemBuilder: (BuildContext context, int index) {
          return Box(
            title: listTypes[index].typeName,
            id: listTypes[index].id,
          );
        }
    );
  }


  Widget rowPost(FullPost post, int ind){
    return Card(
      child: Row(
        children: <Widget>[
          //imageGallery(),
          imageGalery3(post.photoPath, post.solvedPhotoPath),
          Expanded( child: packedThings(post, ind)),
          solvedColor(post),
        ],
      ),
    );
  }



  Widget solvedColor(FullPost post) => Container(
    constraints: BoxConstraints(
      minHeight: 120,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
        color: (post.statusId == 2) ? Colors.white : Colors.green
    ),
  );


  void _updateImageIndex(int index) {
    setState(() => _currentImageIndex = index);
  }


  Widget packedThings(FullPost post, int ind) => Container(
    constraints: BoxConstraints(
      maxHeight: 120,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(post, ind),
        Expanded(child: SizedBox()),
        description(post),
        Expanded(child: SizedBox()),
        actionsButtons(post),
      ],
    ),
  );

  Widget userInfoRow(FullPost post, int ind) => Row(
    children: <Widget>[
      InkWell(
        child: CircleImage(
          userPhotoURL + post.userPhoto,
          imageSize: 36.0,
          whiteMargin: 2.0,
          imageMargin: 6.0,
        ),
        onTap: (){
          if(ind == 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewUserProfilePageIns(post.userId)),
            );
        },
      ),
      InkWell(
        child: Text(
          post.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: (){
          if(ind == 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewUserProfilePageIns(post.userId)),
            );
        },
      ),
      Expanded(child: SizedBox()),
      (post.statusId == 2)
          ? FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: Colors.green)),
        color: Colors.lightGreen,
        child: Text(
          "Reši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstitutionSolvePage(postId: post.postId, id: insId)),
          );
        },
      ).showCursorOnHover
          : SizedBox(),
      SizedBox(width: 10,),
    ],
  );

  Widget imageGallery(FullPost post) => Container(
    constraints: BoxConstraints(
      maxHeight: 180.0, // changed to 400
      minHeight: 100.0, // changed to 200
      maxWidth: 250,
      minWidth: 250,
    ),
    child: Image(image: NetworkImage(userPhotoURL + post.photoPath)),
  );


  Widget location(FullPost post) => Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(post.address, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          )
        ],
      )
  );



  Widget category(FullPost post) => Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(post.typeName, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          )
        ],
      )
  );

  Widget imageGalery3(String image, String image2){
    List<String> imgList=[];
    imgList.add(userPhotoURL + image);
    image2 != "" && image2 != null ?  imgList.add(userPhotoURL + image2) : image2="";
    return SizedBox(
      height: 120.0,
      width: 120.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 6.0,
        dotIncreasedColor: Colors.green,
        dotBgColor: Colors.transparent,
        dotPosition: DotPosition.bottomCenter,
        dotVerticalPadding: 10.0,
        showIndicator: image2 != "" && image2 != null ? true : false,
        indicatorBgPadding: 7.0,
        images: image2 != "" && image2 != null ? [
          NetworkImage(imgList[0]),
          NetworkImage(imgList[1])
        ]
        : [
          NetworkImage(imgList[0])
        ]
      ),
    );
  }

  Widget actionsButtons(FullPost post) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.thumbUpOutline, color: Colors.lightGreen),
                onPressed: () {
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(post.likeNum.toString()),
              ),
              IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(post.dislikeNum.toString()),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.green),
                onPressed: () {
                  //showCommentsDialog(context, post.postId);
                },
              ),
              Text(post.commNum.toString()),
              Expanded(child: SizedBox()),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );



  Widget description(FullPost post){
    if(post.description.length >= 25){
      post.description = post.description.substring(0,25);
      post.description = post.description.replaceRange(23, 25, "...");
    }

    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10,),
          Flexible(
            child: Text(post.description),
          )
        ],
      )
    );
  } 


















  @override
  void initState() {
    super.initState();
    _getUnsolvedPosts();
    _getPostType();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CenteredViewPost(
        child:  indikator == 0 ?
        ListView.builder(
            padding: EdgeInsets.only(bottom: 30.0),
            itemCount: listUnsolvedPosts == null ? 0 : listUnsolvedPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return rowPost(listUnsolvedPosts[index], 0);
            }
        )
            : ListView.builder(
            padding: EdgeInsets.only(bottom: 30.0),
            itemCount: listFilteredPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return rowPost(listFilteredPosts[index], 0);
            }
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 300, top: 50),
        width: 500,
        child: listTypes != null ?
        buildList()
            : Text('Neki tekst'),
      ),
      Container(
        padding: EdgeInsets.only(left: 250, top: 10),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(11.0),
              side: BorderSide(color: Colors.green)),
          color: Colors.lightGreen,
          child: Text(
            "Primeni filter",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _getFiltered(institution.cityId);
          },
        )
      )
    ]);
  }
}








class Box extends StatefulWidget {
  final String title;
  final int id;

  Box({this.title, this.id});

  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Checkbox(
          value: selected,
          onChanged: (bool val) {
            setState(() {
              selected = val;
              if (selected == true) {
                listSelectedTypes.add(widget.id);
                print(listSelectedTypes);
              }
              else {
                List<int> lista = new List();
                for (int i = 0; i < listSelectedTypes.length; i++) {
                  if (listSelectedTypes[i] != widget.id) {
                    lista.add(listSelectedTypes[i]);
                  }
                }
                listSelectedTypes = lista;
                print(listSelectedTypes);
              }

            });
          }),
    );
  }
}
