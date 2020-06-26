import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictoshare/services/auth.dart';
import 'package:pictoshare/theme/theme.dart';
import 'package:flutter_otp/flutter_otp.dart';

import 'otp.dart';



class phoneVerify extends StatefulWidget {
  @override
  _phoneVerifyState createState() => _phoneVerifyState();
}

class _phoneVerifyState extends State<phoneVerify> {
  final AuthService _auth = AuthService();
  TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: 240,
                              constraints: const BoxConstraints(
                                  maxWidth: 500
                              ),
                              margin: const EdgeInsets.only(top: 100),
                              decoration: const BoxDecoration(color: Color(0xFFE1E0F5), borderRadius: BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('TheGorgeousOtp',
                            style: TextStyle(color: MyColors.primaryColor, fontSize: 30, fontWeight: FontWeight.w800)))
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Container(
                        constraints: const BoxConstraints(
                            maxWidth: 500
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: 'We will send you an ', style: TextStyle(color: MyColors.primaryColor)),
                            TextSpan(
                                text: 'One Time Password ', style: TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
                            TextSpan(text: 'on this mobile number', style: TextStyle(color: MyColors.primaryColor)),
                          ]),
                        )),
                    Container(
                      height: 40,
                      constraints: const BoxConstraints(
                          maxWidth: 500
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                        ),
                        controller: phoneController,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        placeholder: '+33...',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      constraints: const BoxConstraints(
                          maxWidth: 500
                      ),
                      child: RaisedButton(
                        onPressed: () {print(phoneController.text);
                        _auth.sendOtp(phoneController.text);
                        _auth.submitPhoneNumber(phoneController.text);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OTP()),);
                        //_auth.submitPhoneNumber(phoneController.text);
                        //sendOtp('6206014527');  //Pass phone number as String
                        },
                        color: MyColors.primaryColor,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  color: MyColors.primaryColorLight,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
