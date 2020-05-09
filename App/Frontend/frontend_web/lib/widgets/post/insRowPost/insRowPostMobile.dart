import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewProfile/viewProfilePageIns.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Color greenPastel = Color(0xFF00BFA6);

class InsRowPostMobileWidget extends StatefulWidget {
  final FullPost posts;
  final int indicator;

  InsRowPostMobileWidget(this.posts, this.indicator);

  @override
  _InsRowPostMobileWidgetState createState() => _InsRowPostMobileWidgetState(posts, indicator);
}

class _InsRowPostMobileWidgetState extends State<InsRowPostMobileWidget> {
  FullPost post;
  int _currentImageIndex = 0;
  int indicator;

  _InsRowPostMobileWidgetState(FullPost post1, int indicator1) {
    this.post = post1;
    this.indicator = indicator1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : rowPost(); //buildPostList()
  }

  Widget rowPost(){
    return Card(
      child: Row(
        children: <Widget>[
          //imageGallery(),
          Expanded( child: imageGallery2(post.photoPath, post.solvedPhotoPath)),
          Expanded( child: packedThings()),
          solvedColor(),
        ],
      ),
    );
  }

  Widget solvedColor() => Container(
    constraints: BoxConstraints(
      minHeight: 180,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
      color: (post.statusId == 2) ? Colors.white : greenPastel
    ),
  );

  Widget packedThings() => Container(
    constraints: BoxConstraints(
      maxHeight: 180,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(),
        Expanded(child: SizedBox()),
        description(),
        Expanded(child: SizedBox()),
        actionsButtons(),
      ],
    ),
  );

  Widget userInfoRow() => Row(
    children: <Widget>[
      InkWell(
        child: CircleImage(
          userPhotoURL + post.userPhoto,
          imageSize: 36.0,
          whiteMargin: 2.0,
          imageMargin: 6.0,
        ),
        onTap: (){
          if(indicator == 1)
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
          if(indicator == 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewUserProfilePageIns(post.userId)),
            );
        },
      ),
      Expanded(child: SizedBox()),
      PopupMenuButton<String>(
        onSelected: (String choice) {
          choicePostIns(choice);
        },
        itemBuilder: (BuildContext context) {
          return ConstantsPostIns.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
      SizedBox(width: 10,),
    ],
  );

  void choicePostIns(String choice) {
    if (choice == ConstantsPostIns.PogledajObjavu) {
      print("Pogledaj objavu.");
    } else if (choice == ConstantsPostIns.Resi) {
      print("Resi.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InstitutionSolvePage(postId: post.postId, id: insId)),
      );
    }
  }

  Widget imageGallery() => Container(
    constraints: BoxConstraints(
      maxHeight: 180.0, // changed to 400
      minHeight: 100.0, // changed to 200
      maxWidth: 250,
      minWidth: 250,
    ),
    child: Image(image: NetworkImage(userPhotoURL + post.photoPath)),
  );

  void _updateImageIndex(int index) {
    setState(() => _currentImageIndex = index);
  }

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
                maxHeight: 180.0, // changed to 400
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

  Widget actionsButtons() =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.thumbUpOutline, color: greenPastel),
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
                icon: Icon(Icons.chat_bubble_outline, color: greenPastel),
                onPressed: () {
                },
              ),
              Text(post.commNum.toString()),
              Expanded(child: SizedBox()),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );

  Widget location() => Container(
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

  Widget category() => Container(
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

  Widget description() => Container(
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
}

class PhotoCarouselIndicator extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;

  PhotoCarouselIndicator({
    @required this.photoCount,
    @required this.activePhotoIndex,
  });

  Widget _buildDot({bool isActive}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: isActive ? 7.5 : 6.0,
          width: isActive ? 7.5 : 6.0,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(photoCount, (i) => i)
          .map((i) => _buildDot(isActive: i == activePhotoIndex))
          .toList(),
    );
  }
}