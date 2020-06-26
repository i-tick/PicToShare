//
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:pictoshare/models/user.dart';
//import 'package:pictoshare/services/auth.dart';

//import 'package:pictoshare/shared/loading.dart';
//import 'package:provider/provider.dart';
//
//import '../home/home.dart';
//
//class Verification extends StatefulWidget {
//  @override
//  _VerificationState createState() => _VerificationState();
//
//}
//
//class _VerificationState extends State<Verification> {
//  final AuthService _auth = AuthService();
//  bool loading = false;
//  String verifyphone="Verify your Phone";
//  String verifyemail="Verify your Email";
//  //final user = Provider.of<User>(context);
//  FirebaseUser user = FirebaseAuth.instance.currentUser() as FirebaseUser;
//  @override
//  Widget build(BuildContext context) {
//    final user = Provider.of<User>(context);
//    return loading ? Loading() : Scaffold(
//      backgroundColor: Colors.brown[100],
//      appBar: AppBar(
//        backgroundColor: Colors.brown[400],
//        elevation: 0.0,
//        title: Text('Sign up to Brews and Beans'),
//        actions: <Widget>[
//        ],
//      ),
//      body: Container(
//        height: 36.0,
//        padding: const EdgeInsets.all(8.0),
//        margin: const EdgeInsets.symmetric(horizontal: 8.0),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(5.0),
//          color: Colors.lightGreen[500],
//        ),
//        child: Column(
//            children: <Widget>[
//          new Row(
//            children: <Widget>[
//            Center(
//              child: RaisedButton(
//              onPressed:null,
//
//                child: Text(verifyemail),
//            ),
//          )
//        ],
//      ),
//          new Row(
//          children: <Widget>[
//            Center(
//              child: RaisedButton(
//                onPressed: null,
//                child: Text(verifyphone),
//            ),
//          )
//        ],
//      ),
//          new Row(
//          children: <Widget>[
//            Center(
//              child: RaisedButton(
//                onPressed: (){return Home();},
//                child: Text("Skip"),
//              ),
//            )
//            ],
//          ),
//
//        ],
//        ),
//        ),
//    );
//  }
//}
//
//
//
