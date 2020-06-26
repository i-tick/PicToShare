import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pictoshare/models/user.dart';
import 'package:pictoshare/pages/dashboard.dart';
import 'package:pictoshare/screens/authenticate/VerificationPhone.dart';
import 'package:pictoshare/services/auth.dart';
import 'package:pictoshare/theme/theme.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  bool loading = false;
  String verifyphone="Verify your Phone";
  String verifyemail="Verify your Email";
  String verification="Have u Verified?";

  @override

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user.phone==true)
      {
        setState(() => verifyphone = "Phone Verified");
      }
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("Welcome to PicToShare"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(90.0),

        child: Column(
          children: <Widget>[
                new Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(10.0),
                        onPressed: () async {dynamic result = await _auth.emailverify(user);
                        setState(() => verifyemail = "Email sent/ Resend Email");
                        print(user.email);
                        if (result.isEmailVerified) user.email=true;
                        if (user.email)
                        {
                          setState(() => verifyemail = "Verified");
                        }
                        },
                        color: MyColors.primaryColor,
                        child: Text(verifyemail,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                      ),
                    ),
                  ],
                ),
            SizedBox(

              height: 20.0,
            ),
                new Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(10.0),
                        onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => phoneVerify()),
                        );},
                        color: MyColors.primaryColor,
                        child: Text(verifyphone,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                      ),
                    )
                  ],
                ),
            SizedBox(

              height: 20.0,
            ),
            new Row(
              children: <Widget>[

                RaisedButton(
                  onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );},
                  color: MyColors.primaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Skip Verification", style: TextStyle(color: Colors.white,fontSize: 20.0),),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            color: MyColors.primaryColorLight,
                          ),
                          //child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(

              height: 20.0,
            ),
            new Row(
              children: <Widget>[
                RaisedButton(

                  onPressed: () async {
                    AuthResult result = await _auth.signInWithEmailAndPassword('aitikdandapat@gmail.com','1234567890');
                    FirebaseUser result1 = result.user;
                    if (result1.isEmailVerified) user.email=true;
                    if (user.email)
                    {
                      setState(() => verifyemail = "Verified Email");
                    }
                    else
                    {
                      Fluttertoast.showToast(
                          msg: "Email is not Verified",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    if (user.phone==true)
                    {
                      setState(() => verifyemail = "Verified Phone");
                    }
                    else
                    {
                      Fluttertoast.showToast(
                          msg: "Phone is not Verified",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  },
                  color: MyColors.primaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))
                  ),
                  child: Container(

                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(verification, style: TextStyle(color: Colors.white,fontSize: 20.0),),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            color: MyColors.primaryColorLight,
                          ),
                          //child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
