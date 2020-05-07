import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/comment.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/prefer_universal/html.dart' as html;


class InstitutionSolvePage extends StatefulWidget {
  final int postId;
  final int id;
  InstitutionSolvePage({Key key, this.postId, this.id});

  @override
  _InstitutionSolvePageState createState() => _InstitutionSolvePageState(postId);

}

class _InstitutionSolvePageState extends State<InstitutionSolvePage> {

  TextEditingController description = new TextEditingController();
  int postId;

  _InstitutionSolvePageState(int idp) {
    this.postId = idp;
  }



  Image image;
  String error;
  String photoName = '';
  Uint8List data;
  String unknownImageText = "";
  String successText = "";
  int instId;

  @override
  initState() {
    super.initState();
    instId = widget.id;
  }

  solve(int postId, int institutionId, String description) {
    if (photoName != null && photoName != '') {
      String base64Image = base64Encode(data);
      APIServices.addImageWeb(base64Image).then((res){

        var res1 = jsonDecode(res);
        APIServices.solveFromTheInstitution(TokenSession.getToken, postId, institutionId, description, res1);
        Navigator.pop(context);

        setState(() {
          successText = "Uspešno ste rešili objavu.";
          unknownImageText = "";
        });
      });
    }
    else {
      setState(() {
        unknownImageText = "Morate uneti sliku ukoliko želite da rešite objavu.";
      });
      throw Exception("Morate uneti sliku ukoliko želite da rešite objavu.");
    }
  }




  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
        error = err.toString();
      }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
        encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          photoName = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  Widget descriptionPart() {
    return Material(
      child: Container(
        width:600,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            cursorColor: Colors.black,
            controller: description,
            minLines: 5,
            maxLines: 15,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Opis rešenja',
              filled: true,
              fillColor: Color(0xffffffff),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 5),
        width: 600,
        child: ListView(
          children: <Widget>[
            FlatButton(
              color: Colors.green[800],
              child: Text(
                "Dodaj sliku",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                pickImage();
              },
            ),
            SizedBox(
              height: 25,
            ),
            data != null ?
            Container(
              constraints: BoxConstraints(
                maxHeight: 400.0, // changed to 400
                minHeight: 200.0, // changed to 200
                maxWidth: double.infinity,
                minWidth: double.infinity,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200],
                    width: 1.0,
                  ),
                ),
              ),
              child: ClipRect(
                  child: Image.memory(data, height: 400.0,
                    width: 200.0,
                    fit: BoxFit.cover,)
              ),
            )
             :
            SizedBox(
              height: 25,
            ),
            descriptionPart(),
            SizedBox(
              height: 15,
            ),
            FlatButton(
              color: Colors.green[800],
              child: Text(
                "Reši",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                solve(postId, instId, description.text);
              },
            ),
            SizedBox(
              height: 10,
            ),
            unknownImageText != '' ? Center(
                child: Text(
                  unknownImageText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                  ),
                )
            )
            : Center(
                child: Text(
                  successText,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                )
            ),
          ],
        ),
      )
    );
  }

}