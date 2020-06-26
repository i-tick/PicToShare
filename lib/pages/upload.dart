import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pictoshare/models/user.dart';
import 'package:pictoshare/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Upload extends StatefulWidget {
  final AuthService _auth = AuthService();
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final firestoreInstance = Firestore.instance;



  String _fileName1="";
  String hash="";
  String url;
  String _path1 = 'No File Choosen';
  Map<String, String> _paths1;

  File file;
  bool _multiPick1 = false;
  bool _hasValidMime1 = true;
  FileType _pickingType1=FileType.image;

  String _filePath;

  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.image);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      setState((){this._filePath = filePath;});
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fileName1="";
      }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xff104670),
          title: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: <Widget>[
                    Row(
                      children:
                      <Widget>[

                        SingleChildScrollView(
                            child: Container(
                                width: 200,
                                child: Text("Upload Image",style: new TextStyle(fontSize: 15.0, color: Colors.white),))),
                        //child: new FlatButton(onPre,new Text("${widget.add}",style: new TextStyle(fontSize: 15.0),)))),

                      ],
                    ),
                  ],

                ),
              )
          ),
          //leading:new Text("hi"),
        ),



        body: new ListView(

          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20.0),
                child: new Form(

                  //key: formKey,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: buildInputs() + buildSubmitButtons(),
                  ),
                )
            ),
          ],
        )
    );
  }

  List<Widget> buildInputs() {
    final user = Provider.of<User>(context);
    return [
      new Row(
        children: <Widget>[
          new Flexible(child: new Column(
            children: <Widget>[
              //new Image.asset('images/16x9@2x.png')
            ],
          )),
          new Flexible(child: new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0)),
              new Text(user.name,style: TextStyle(fontSize: 22.0),)

            ],
          ))
        ],
      ),
      Divider(
        color: Colors.grey,
        height: 10.0,
      ),
      new Text('Add Image',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
      SizedBox(height: 20.0),
      new Text('Add Hash Tags!!'),

      new TextFormField(
        decoration: new InputDecoration(hintText: 'Hash Tags',border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.grey))),
        validator: (value) => value.isEmpty ? 'Hash Tags can\'t be empty' : null,
        onChanged: (val){
          setState(() =>hash=val);
        },

      ),

      SizedBox(height: 20.0),

      new Container(
          child:
          new Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: new SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('Image of the product'),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: new Center(
                      child: _filePath == null
                          ? new Text('No file selected.')
                          : new Text('Path' + _filePath),
                    ),
                  ),
                  new FloatingActionButton(
                    onPressed: getFilePath,
                    tooltip: 'Select file',
                    child: new Icon(Icons.sd_storage),
                  ),

                ],
              ),
            ),
          )),
      SizedBox(height: 20.0),


    ];
  }


  List<Widget> buildSubmitButtons() {
    final user = Provider.of<User>(context);
    if (true) {
      return [
        new OutlineButton(
            child: new Text('Upload Image', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
            onPressed: ()

      async {

        file = File(this._filePath);


        //Create a reference to the location you want to upload to in firebase
        StorageReference reference = _storage.ref().child("images/");

        //Upload the file to firebase
        StorageUploadTask uploadTask = reference.putFile(file);
        StorageTaskSnapshot s=await uploadTask.onComplete;
        url=await s.ref.getDownloadURL();
        print("url is "+url);

        firestoreInstance.collection("users").document(user.uid).setData(
            {
              "userid" : user.uid,
              "Name": user.name,
              "Hashtags": hash,
              "url": url
            },merge : true).then((_){
          print("success!");
        });


      }
    ,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
        ),
      ];
    }
  }

}

