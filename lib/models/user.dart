class User {
  
  final String uid;
  bool email;
  bool phone;
  String name;

  User({this.uid,this.email,this.phone,this.name})
  {
   this.email=false;
   this.phone=false;
   this.name="";
  }

}