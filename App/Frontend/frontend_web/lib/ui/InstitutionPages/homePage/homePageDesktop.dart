import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/postType.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewProfile/viewProfilePageIns.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostDesktop.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


List<int> listSelectedTypes = new List();
int indikator = 0;

class HomeInstitutionDesktop extends StatefulWidget {

  final int id;
  HomeInstitutionDesktop({Key key, this.id});

  @override
  _HomeInstitutionDesktopState createState() => _HomeInstitutionDesktopState();
}

class _HomeInstitutionDesktopState extends State<HomeInstitutionDesktop> {

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

  _getPostType() async {
    var res =  await APIServices.getPostType(TokenSession.getToken);
    Iterable list = json.decode(res.body);
    List<PostType> postTypes = List<PostType>();
    postTypes = list.map((model) => PostType.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listTypes = postTypes;
      });
    }
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




  @override
  void initState() {
    super.initState();
    _getUnsolvedPosts();
    _getPostType();
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
          Expanded( child: imageGallery2(post.photoPath, post.solvedPhotoPath)),
          Expanded( child: packedThings(post, ind)),
          solvedColor(post),
        ],
      ),
    );
  }



  Widget solvedColor(FullPost post) => Container(
    constraints: BoxConstraints(
      minHeight: 180,
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
      maxHeight: 180,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(post, ind),
        category(post),
        Expanded(child: SizedBox()),
        description(post),
        Expanded(child: SizedBox()),
        location(post),
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



  Widget imageGallery2(String image, String image2) {
    List<String> imgList=[];
    imgList.add(userPhotoURL + image);
    image2 != "" && image2 != null ?  imgList.add(userPhotoURL + image2) : image2="";
    return Column(children: <Widget>[
      GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  _updateImageIndex(index);
                },
                enableInfiniteScroll: false,
              ),
              items: imgList.map((item) => Container(
                constraints: BoxConstraints(
                  maxHeight: 200.0, // changed to 400
                  minHeight: 100.0, // changed to 200
                  maxWidth: 250,
                  minWidth: 250,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[200],
                      width: 1.0,
                    ),
                  ),
                ),
                child: Center(
                    child: Image.network(item, fit: BoxFit.fitWidth, width: MediaQuery.of(context).size.width, )
                ),
              )).toList(),

            ),
          ],
        ),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (imgList.length > 1) ?
          Container(
              height: 30,
              child: PhotoCarouselIndicator(
                photoCount: imgList.length,
                activePhotoIndex: _currentImageIndex,
              )) : Container( width: 1, height: 1,),
        ],)
    ],
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



  Widget description(FullPost post) => Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(post.description),
          )
        ],
      )
  );

  @override
  Widget build(BuildContext context) {
    print(listSelectedTypes.toString());
    print(indikator.toString());
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
      CollapsingInsNavigationDrawer(),
      Container(
        padding: EdgeInsets.only(left: 150, top: 50),
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

                if (listSelectedTypes.length > 0) {
                  indikator = 1;
                }
              }
              else {
                List<int> lista = new List();
                if (listSelectedTypes != null ) {
                  for (int i = 0; i < listSelectedTypes.length; i++) {
                    if (listSelectedTypes[i] != widget.id) {
                      lista.add(listSelectedTypes[i]);
                    }
                  }
                  listSelectedTypes = lista;
                  if (listSelectedTypes.length == 0) {
                    indikator = 0;
                  }
                }
                }


            });
          }),
    );
  }
}
