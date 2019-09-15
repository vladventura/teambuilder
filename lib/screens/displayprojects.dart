import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teambuilder/util/constants.dart';

import 'package:flash/flash.dart';

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
              //TODO: This is the product of lazyness. Now I have to refactor this thing so I can have it work as I need
              //I need it so the snapshot briengs the whole document, so I can now decide which set of buttons to build.
              //TODO: Step two of this process will be to adjust this with what follows the then() of the first step.
              //TODO: Step three will be to check if the team accepts more members or not, and then check if the user is one of these members
              if (!snapshot.data == true) {
                return Row(
                  children: <Widget>[
                    buildJoinButton(document),
                    buildButtonSeparator(),
                    buildCancelButton(),
                  ],
                );
              } else {
                return Row(
                  children: <Widget>[
                    buildLeaveButton(document),
                    buildButtonSeparator(),
                    buildCancelButton(),
                  ],
                );
              }
            }
          }
          return CircularProgressIndicator();
        });
  }

  RaisedButton buildLeaveButton(DocumentSnapshot document) {
    return RaisedButton(
      color: Colors.grey,
      child: Text('Leave Project'),
      onPressed: () async {
        showFlash(
            context: context,
            duration: Duration(seconds: 1),
            builder: (context, controller) {
              return Flash(
                controller: controller,
                style: FlashStyle.grounded,
                backgroundColor: Constants.sideBackgroundColor,
                boxShadows: kElevationToShadow[4],
                child: FlashBar(
                  message: Text(
                    "Leaving team...",
                    style: TextStyle(
                      color: Constants.generalTextColor,
                    ),
                  ),
                ),
              );
            });
        FirebaseUser _user;
        await FirebaseAuth.instance.currentUser().then((ref) => _user = ref);
        CollectionReference projects = _db.collection('projects');
        CollectionReference users = _db.collection('users');
        DocumentReference thisProject = projects.document(document.documentID);
        DocumentReference userDocument = users.document(_user.displayName);
        thisProject.updateData({
          'joinedUsers': FieldValue.arrayRemove([_user.displayName])
        });
        userDocument.updateData({
          'joinedProjects': FieldValue.arrayRemove([
            document.documentID,
          ])
        });
        Navigator.pop(context);
        showFlash(
            context: context,
            duration: Duration(seconds: 1),
            builder: (context, controller) {
              return Flash(
                controller: controller,
                style: FlashStyle.grounded,
                backgroundColor: Constants.sideBackgroundColor,
                boxShadows: kElevationToShadow[4],
                child: FlashBar(
                  message: Text(
                    "Left team successfully.",
                    style: TextStyle(
                      color: Constants.generalTextColor,
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  SizedBox buildButtonSeparator() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
    );
  }

  RaisedButton buildJoinButton(DocumentSnapshot document) {
    return RaisedButton(
      child: Text("Join Project"),
      color: Constants.acceptButtonColor,
      onPressed: () async {
                    showFlash(
              context: context,
              duration: Duration(seconds: 1),
              builder: (context, controller){
                return Flash(
                  controller: controller,
                  style: FlashStyle.grounded,
                  backgroundColor: Constants.sideBackgroundColor,
                  boxShadows: kElevationToShadow[4],
                  child: FlashBar(
                    message: Text(
                      "Joining team...",
                      style: TextStyle(
                        color: Constants.generalTextColor,
                      ),),
                  ),
                );
              }
            );
        FirebaseUser _user;
        await FirebaseAuth.instance.currentUser().then((ref) => _user = ref);
        CollectionReference projects = _db.collection('projects');
        CollectionReference users = _db.collection('users');
        DocumentReference thisProject = projects.document(document.documentID);
        DocumentReference userDocument = users.document(_user.displayName);
        thisProject.updateData({
          'joinedUsers': FieldValue.arrayUnion([_user.displayName])
        });
        userDocument.updateData({
          'joinedProjects': FieldValue.arrayUnion([
            document.documentID,
          ])
        });
        Navigator.pop(context);
                    showFlash(
              context: context,
              duration: Duration(seconds: 1),
              builder: (context, controller){
                return Flash(
                  controller: controller,
                  style: FlashStyle.grounded,
                  backgroundColor: Constants.sideBackgroundColor,
                  boxShadows: kElevationToShadow[4],
                  child: FlashBar(
                    message: Text(
                      "Team joined!",
                      style: TextStyle(
                        color: Constants.generalTextColor,
                      ),),
                  ),
                );
              }
            );
      },
    );
  }

  RaisedButton buildCancelButton() {
    return RaisedButton(
      child: Text("Cancel"),
      color: Constants.cancelButtonColor,
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Future<bool> belongs(DocumentSnapshot document) async {
    FirebaseUser _user;
    FirebaseAuth.instance.currentUser().then((ref) => _user = ref);
    CollectionReference projects = _db.collection('projects');
    DocumentReference thisProject = projects.document(document.documentID);
    bool isJoined;
    //TODO: Change this to return this future right here.
    await thisProject.get().then((dmnt) {
      isJoined = document.data['joinedUsers'].contains(_user.displayName);
    });
    return isJoined;
  }
}
