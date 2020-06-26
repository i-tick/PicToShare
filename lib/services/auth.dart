
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictoshare/models/user.dart';
import 'package:sms/sms.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _otp, _minOtpValue, _maxOtpValue;
  FirebaseUser _firebaseUser;

  // create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  // register with email and passsword
  Future registerWithEmailAndPassword(String email, String password,String Name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      User(name:Name);
      final firestoreInstance = Firestore.instance;
      firestoreInstance.collection("Register").document(user.uid).setData(
          {
            "userid" : user.uid,
            "Name": Name,
            'Email':email,
          },merge : true).then((_){
        print("success!");
      });
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

   Future emailverify(User user) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: 'aitikdandapat@gmail.com', password: '1234567890');
      FirebaseUser user = result.user;
      //Future<FirebaseUser> a = _auth.currentUser();
      await user.sendEmailVerification();
      return user;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  void generateOtp([int min = 100000, int max = 999999]) {
    //Generates four digit OTP by default
    _minOtpValue = min;
     _maxOtpValue = max;
    _otp = _minOtpValue + Random().nextInt(_maxOtpValue - _minOtpValue);
  }

  void sendOtp(String phoneNumber,
      [String messageText,
        int min = 1000,
        int max = 9999,
        String countryCode = '+91']) {
    //function parameter 'message' is optional.
    generateOtp(min, max);
    SmsSender sender = new SmsSender();
    String address = (countryCode ?? '+91') +
        phoneNumber; // +1 for USA. Change it according to use.

    /// Use country code as per your requirement.
    /// +1 : USA / Canada
    /// +91: India
    /// +44: UK
    /// For other countries, please refer https://countrycode.org/
    print(address);
    sender.sendSms(new SmsMessage(
        address, 'Your OTP is : ' + _otp.toString()));
  }

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;

  Future<void> submitPhoneNumber(String u) async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91" + u.toString().trim();
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more readable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(AuthException error) {
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      this._code=code;
      print(code);
      print('codeSent');
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `milliseconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }


  Future<bool> submitOTP(String text) {
    /// get the `smsCode` from the user
    String smsCode = text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode);
    print(this._phoneAuthCredential);
    print(this._verificationId);
    print(_code);
    if (this._code==smsCode)
      {
        print("Successfull");
      }
    var value = login();
    print(value);
    print("hello"+value.toString());
    return value;

  }

  Future login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
      });
    } catch (e) {

    print(e.toString());
    }
  }

}