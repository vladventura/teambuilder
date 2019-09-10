import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teambuilder/util/constants.dart';

class DisplayProjects extends StatefulWidget {
  _DisplayProjectsState createState() => _DisplayProjectsState();
}

class _DisplayProjectsState extends State<DisplayProjects> {
  final _db = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _db.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data.documents
                  .map((document) => buildProject(document))
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Card buildProject(DocumentSnapshot document) {
    return Card(
      child: Container(
        decoration: Constants.buttonDecoration(),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.07,
        child: FlatButton(
          color: Constants.formInactiveColor,
          textColor: Constants.flavorTextColor,
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  document.data['name'],
                  textAlign: TextAlign.center,
                ),
                Text(
                  document.data['originator'],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          onPressed: () {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Constants.sideBackgroundColor,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(document.data['description']),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                        Container(
                          child: Text("Members!"),
                        ),
                        getTextWidgets(document.data['joinedUsers']),
                        Row(
                          children: <Widget>[
                            Container(
                              child: RaisedButton(
                                child: Text("Join Project"),
                                color: Constants.acceptButtonColor,
                                onPressed: () async{
                                  FirebaseUser _user = await FirebaseAuth.instance.currentUser();
                                  CollectionReference projects = _db.collection('projects');
                                  CollectionReference users = _db.collection('users');
                                  DocumentReference thisProject = projects.document(document.documentID);
                                  DocumentReference userDocument = users.document(_user.displayName);
                                  thisProject.updateData({
                                    'joinedUsers': FieldValue.arrayUnion([
                                      _user.displayName
                                    ])
                                  });
                                  userDocument.updateData({
                                    'joinedProjects': FieldValue.arrayUnion([
                                      document.documentID,
                                    ])
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            Container(
                              child: RaisedButton(
                                child: Text("Cancel"),
                                color: Constants.cancelButtonColor,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    title: Text(document.data['name'] +
                        ' by ' +
                        document.data['originator']),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget getTextWidgets(List<dynamic> users){
    return Container(
      alignment: Alignment.centerLeft,
      child: new Column(
        children: users.map((user) => new Text(user)).toList()),
    );
  }

  Future <List<Widget>> joinCancelButtonRow(DocumentSnapshot document) async {
    
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    CollectionReference projects = _db.collection('projects');
    CollectionReference users = _db.collection('users');
    DocumentReference thisProject = projects.document(document.documentID);
    DocumentReference userDocument = users.document(_user.displayName);
    var isJoined = await thisProject.get().then((dcmnt){
      return document['joinedUsers'].contains(_user.displayName);
    });
    if (!isJoined) {return [
        Container(
        child: RaisedButton(
          child: Text("Join Project"),
          color: Constants.acceptButtonColor,
          onPressed: () async{
            thisProject.updateData({
              'joinedUsers': FieldValue.arrayUnion([
                _user.displayName
              ])
            });
            userDocument.updateData({
              'joinedProjects': FieldValue.arrayUnion([
                document.documentID,
                ])
              });
            },
          ),
        ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
      ),
      Container(
        child: RaisedButton(
          child: Text("Cancel"),
              color: Constants.cancelButtonColor,
                onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    ];} else {
      return [
        Container(
          child: RaisedButton(
            child: Text('Already Joined!'),
            color: Colors.grey,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
      ),
      Container(
        child: RaisedButton(
          child: Text("Cancel"),
              color: Constants.cancelButtonColor,
                onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      ];
    }
  }
}
