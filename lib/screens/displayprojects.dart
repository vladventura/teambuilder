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
  int _groupValue = 1;
  String _specialization;

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
            // return showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return AlertDialog(
            //         backgroundColor: Constants.sideBackgroundColor,
            //         content: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: <Widget>[
            //             Container(
            //               child: Text(
            //                   "The creator of the project advised that this individual project is aimed at ${document.data['complexity']} level developers."),
            //             ),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.03,
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: Text(document.data['description']),
            //             ),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.03,
            //             ),
            //             Container(
            //               child: Text("Members!"),
            //             ),
            //             getTextWidgets(document.data['joinedUsers']),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.03,
            //             ),
            //             Container(
            //               child: Text("Languages Used!"),
            //             ),
            //             getGeneralTexts(document.data['languagesUsed']),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.03,
            //             ),
            //             Container(
            //               child: Text("Technologies Used!"),
            //             ),
            //             getGeneralTexts(document.data['technologiesUsed']),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.03,
            //             ),
            //             Container(
            //               child: Text(
            //                   "${document.data['joinedUsers'].length}/${document.data['teamMembers']} members joined."),
            //             ),
            //             buttons(document),
            //           ],
            //         ),
            //         title: Text(document.data['name'] +
            //             ' by ' +
            //             document.data['originator']),
            //       );
            //     });
          },
        ),
      ),
    );
  }

  Widget getTextWidgets(List<dynamic> users) {
    bool isEmpty = (users.length <= 0 || users == null);
    if (!isEmpty)
      return Container(
        alignment: Alignment.centerLeft,
        child:
            new Column(children: users.map((user) => new Text("${user['name']} (${user['specialization']})")).toList()),
      );
    return Container(
      child: Text("Nothing to show here~!"),
    );
  }

  Widget getGeneralTexts(List<dynamic> elements){
    bool isEmpty = (elements.length <= 0 || elements == null);
    if (!isEmpty)
      return Container(
        alignment: Alignment.centerLeft,
        child:
            new Column(children: elements.map((element) => new Text(element)).toList()),
      );
    return Container(
      child: Text("Nothing to show here~!"),
    );
  }

  Widget buttons(DocumentSnapshot document) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot != null) {
            if (snapshot.hasData) {
              bool owner =
                  (document.data['originator'] == snapshot.data.displayName);
              bool belongs = (document.data['joinedUsers']
                      .contains(snapshot.data.displayName) ||
                  owner);
              bool slotAvailable = (document.data['joinedUsers'].length <
                  int.parse(document.data['teamMembers']));
              if (!belongs) {
                if (slotAvailable == true) {
                  return Row(
                    children: <Widget>[
                      buildJoinButton(document),
                      buildButtonSeparator(),
                      buildCancelButton(),
                    ],
                  );
                } else {
                  return FlatButton(
                    child: Text("The team is full."),
                    onPressed: null,
                  );
                }
              } else if (owner) {
                return FlatButton(
                  child: Text("You cannot join your own project!"),
                  onPressed: null,
                );
              } else if (belongs) {
                return Row(
                  children: <Widget>[
                    buildLeaveButton(document),
                    buildButtonSeparator(),
                    buildCancelButton()
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

  void handleRadioChange(DocumentSnapshot document, int val) {
    setState(() {
      _groupValue = val;
      if (val == 1) {
        _specialization = "Frontend";
      } else if (val == 2) {
        _specialization = "Backend";
      }
    });
    // KLUDGE: Popping the alert box and calling it again because it is rendered outside the build tree
    Navigator.of(context).pop();
    _showSpecializationChooser(document);
  }

  Future<Null> _showSpecializationChooser(DocumentSnapshot document) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Most comfortable area?"),
            backgroundColor: Constants.sideBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                    activeColor: Constants.flavorTextColor,
                    groupValue: _groupValue,
                    onChanged: (int val) {
                      handleRadioChange(document, val);
                    },
                    value: 1,
                    title: Text("Frontend"),
                  ),
                  RadioListTile(
                    activeColor: Constants.flavorTextColor,
                    groupValue: _groupValue,
                    onChanged: (int val) {
                      handleRadioChange(document, val);
                    },
                    value: 2,
                    title: Text("Backend"),
                  ),
                  Row(
                    children: <Widget>[
                      buildJoinConfirm(document),
                      buildButtonSeparator(),
                      buildCancelButton()
                    ],
                  ),
                ],
            ),
          );
        });
  }

  RaisedButton buildJoinButton(DocumentSnapshot document) {
    return RaisedButton(
      color: Constants.acceptButtonColor,
      child: Text("Join Project"),
      onPressed: () {
        _showSpecializationChooser(document);
      },
    );
  }

  RaisedButton buildJoinConfirm(DocumentSnapshot document) {
    return RaisedButton(
      child: Text("Join Project"),
      color: Constants.acceptButtonColor,
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
                    "Joining team...",
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
          'joinedUsers': FieldValue.arrayUnion([{
            'name': _user.displayName,
            'specialization': _specialization
          }])
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
            builder: (context, controller) {
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
                    ),
                  ),
                ),
              );
            });
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
}

class DisplayProject extends StatelessWidget{
  DisplayProject({@required this.document});
  final DocumentSnapshot document;

  Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Text("Name"),
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Text("Description"),
          Divider(),
          Text("Blah blah blah"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Text("Members!"),
          Divider(),
          Text("All the members' list"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: null,
                child: Text("Button one"),
              ),
              RaisedButton(
                onPressed: null,
                child: Text("Button two"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}