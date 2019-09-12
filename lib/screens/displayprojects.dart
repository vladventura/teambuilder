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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                          child: Text("Members!"),
                        ),
                        getTextWidgets(document.data['joinedUsers']),
                        buttons(document),
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

  Widget getTextWidgets(List<dynamic> users) {
    return Container(
      alignment: Alignment.centerLeft,
      child: new Column(children: users.map((user) => new Text(user)).toList()),
    );
  }

  FutureBuilder buttons(DocumentSnapshot document) {
    return FutureBuilder(
        future: belongs(document),
        builder: (context, snapshot) {
          if (snapshot != null) {
            if (snapshot.hasData) {
              if (!snapshot.data == true) {
                return Row(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        child: Text("Join Project"),
                        color: Constants.acceptButtonColor,
                        onPressed: () async {
                          FirebaseUser _user;
                          await FirebaseAuth.instance
                              .currentUser()
                              .then((ref) => _user = ref);
                          CollectionReference projects =
                              _db.collection('projects');
                          CollectionReference users = _db.collection('users');
                          DocumentReference thisProject =
                              projects.document(document.documentID);
                          DocumentReference userDocument =
                              users.document(_user.displayName);
                          thisProject.updateData({
                            'joinedUsers':
                                FieldValue.arrayUnion([_user.displayName])
                          });
                          userDocument.updateData({
                            'joinedProjects': FieldValue.arrayUnion([
                              document.documentID,
                            ])
                          });
                          Navigator.pop(context);
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
                );
              } else {
                return Row(
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.grey,
                      child: Text('Leave Project'),
                      onPressed: () async {
                          FirebaseUser _user;
                          await FirebaseAuth.instance
                              .currentUser()
                              .then((ref) => _user = ref);
                          CollectionReference projects =
                              _db.collection('projects');
                          CollectionReference users = _db.collection('users');
                          DocumentReference thisProject =
                              projects.document(document.documentID);
                          DocumentReference userDocument =
                              users.document(_user.displayName);
                          thisProject.updateData({
                            'joinedUsers':
                                FieldValue.arrayRemove([_user.displayName])
                          });
                          userDocument.updateData({
                            'joinedProjects': FieldValue.arrayRemove([
                              document.documentID,
                            ])
                          });
                          Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                    ),
                    RaisedButton(
                        color: Constants.cancelButtonColor,
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                );
              }
            }
          }
          return CircularProgressIndicator();
        });
  }

  Future<bool> belongs(DocumentSnapshot document) async {
    FirebaseUser _user;
    FirebaseAuth.instance.currentUser().then((ref) => _user = ref);
    CollectionReference projects = _db.collection('projects');
    DocumentReference thisProject = projects.document(document.documentID);
    bool isJoined;
    await thisProject.get().then((dmnt) {
      isJoined = document.data['joinedUsers'].contains(_user.displayName);
    });
    return isJoined;
  }
}
