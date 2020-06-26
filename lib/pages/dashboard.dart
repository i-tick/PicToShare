import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pictoshare/models/user.dart';
import 'package:pictoshare/pages/update.dart';
import 'package:pictoshare/pages/upload.dart';
import 'package:pictoshare/services/auth.dart';
import 'package:provider/provider.dart';
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

var b;
class _DashboardState extends State<Dashboard> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


    Firestore.instance.collection("Register").document(user.uid).get().then((value) {
      a=value.data;
      setState(() => b = value.data);
    });
    return Scaffold(
      appBar: new AppBar(
        title: Text(b['Name']),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('logout'),
            icon: Icon(Icons.person),
          )
        ],),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              InkWell(
                child: new UserAccountsDrawerHeader(
                  accountName: Text(b['Name']),
                  accountEmail: null,
                  currentAccountPicture: GestureDetector(
                      child: CircleAvatar(
                        child: Text(b['Name']
                            .toString()),
                      ),),
                  decoration: new BoxDecoration(color: Color(0xff104670)),
                ),
                onTap: (){

                },
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => update()),
                  );

                },
                child: ListTile(
                  title: Text('Update Details'),
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: ListTile(
                  title: Text('Upload Photo'),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Upload()),
                  );
                },
                child: ListTile(title: Text('Log Out')),
              ),
            ],
          )
        ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
                child: Center(child: CircularProgressIndicator()));
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          snapshot.data.documents[index].data['url'],
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        elevation: 0,
                        margin: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: Card(
                          elevation: 0,
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              child: Text(snapshot
                                  .data.documents[index].data['Name']
                                  .toString()),
                            ),
                            title: Text(
                              snapshot
                                  .data.documents[index].data['Hashtags']
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            children: <Widget>[
                              Text(snapshot
                                  .data.documents[index].data['Email']
                                  .toString()),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
