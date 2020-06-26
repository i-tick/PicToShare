import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pictoshare/models/user.dart';
import 'package:pictoshare/pages/dashboard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
//import 'globals.dart' as globals;
class update extends StatefulWidget {
  @override
  _updateState createState() => _updateState();
}
String n,p;
 var a;
ProgressDialog pr;
class _updateState extends State<update> {
  @override  final _formKey = GlobalKey<FormState>();
  //@override  final val = GlobalKey<List>();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    pr = new ProgressDialog(context, showLogs: true);

    Firestore.instance.collection("Register").document(user.uid).get().then((value) {
      a=value.data;
      setState(() => a = value.data);
    });
      return
        Scaffold(

      appBar: AppBar(

        title: Text("Update User Details"),
      ),
      body:
      Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Update Name - '+a['Name'],
                ),
                textAlign: TextAlign.left,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  n=text;
                },
              ),
              TextFormField(
                decoration: InputDecoration(

                  hintText: 'Update Email '+a['Email'],
                ),
                textAlign: TextAlign.left,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Phone Number cannot be empty';
                  }
                  p=text;
                },
              ),
              SizedBox(

                height: 20.0,
              ),

              TextFormField(
                decoration: InputDecoration(

                  hintText: 'Update Phone '+a['Phone'],
                ),
                textAlign: TextAlign.left,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Phone Number cannot be empty';
                  }
                  p=text;
                },
              ),
              SizedBox(

                height: 20.0,
              ),

              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {

                    pr.show();
                    updatedata();
                    pr.hide();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>new Dashboard()));
                  }
                },
                child: Text('Update'),
              )
            ],
          ),
        ),
      ),

    );

  }


  updatedata() {
    final user = Provider.of<User>(context);
    print(n);
    print(p);
    Firestore.instance.collection('Register')
        .document(user.uid)
        .updateData({
      'useruid':user.uid,
      'Name': n,
      'Email':p,
    }).then((_) {
      print("success!");
      ;
    });
  }

}
