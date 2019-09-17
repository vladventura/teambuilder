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
          onPressed: () async {
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    new _DisplayProject(document: document, user: user)));
          },
        ),
      ),
    );
  }
}

class _DisplayProject extends StatefulWidget {
  _DisplayProject({@required this.document, @required this.user});
  final DocumentSnapshot document;
  final FirebaseUser user;
  _DisplayProjectState createState() => new _DisplayProjectState(
        document: document,
        user: user,
      );
}

class _DisplayProjectState extends State<_DisplayProject> {
  _DisplayProjectState({@required this.document, @required this.user});
  final DocumentSnapshot document;
  final FirebaseUser user;
  final Firestore _db = Firestore.instance;
  int _groupValue = 1;
  String _specialization = "Frontend";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Details"),
        backgroundColor: Constants.sideBackgroundColor,
        iconTheme: IconThemeData(
          color: Constants.flavorTextColor,
        ),
        textTheme: TextTheme(
          title: TextStyle(
            color: Constants.generalTextColor,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Constants.mainBackgroundColor,
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        children: <Widget>[
          Text(
            "${document.data['name']} by ${document.data['originator']}",
            style: TextStyle(
              fontSize: 30,
              color: Constants.flavorTextColor,
            ),
          ),
          buildSizedBoxHeight(0.05),
          buildHeaderText("Description"),
          buildDivider(),
          Text(document.data['description'],
              style: TextStyle(fontSize: 18, color: Constants.flavorTextColor)),
          buildSizedBoxHeight(0.1),
          buildHeaderText("Members"),
          buildDivider(),
          buildMembersList(document.data['joinedUsers']),
          buildSizedBoxHeight(0.1),
          buildHeaderText("Languages Used"),
          buildDivider(),
          buildElements(document.data['languagesUsed']),
          buildSizedBoxHeight(0.1),
          buildHeaderText("SDKs and Frameworks Used"),
          buildDivider(),
          buildElements(document.data['technologiesUsed']),
          buildButtons(document, user),
        ],
      ),
    );
  }

  Text buildHeaderText(String headerText) {
    return Text(
      headerText,
      style: TextStyle(
        fontSize: 25,
        color: Constants.generalTextColor,
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1.5,
      color: Constants.acceptButtonColor,
    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * height,
    );
  }

  Widget buildMembersList(List<dynamic> users) {
    bool isEmpty = (users.length <= 0 || users == null);
    if (!isEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: users
                .map((user) => new Text(
                      "${user['name']} (${user['specialization']})",
                      style: TextStyle(
                          fontSize: 18, color: Constants.flavorTextColor),
                    ))
                .toList()),
      );
    return Container(
      child: Text("Nothing to show here~!"),
    );
  }

  Widget buildElements(List<dynamic> elements) {
    bool isEmpty = (elements.length <= 0 || elements == null);
    if (!isEmpty)
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.all(1),
        child: new Column(
            children: elements
                .map((element) => new Text(
                      element,
                      style: TextStyle(
                          fontSize: 18, color: Constants.flavorTextColor),
                    ))
                .toList()),
      );
    return Container(
      child: Text("Nothing to show here~!"),
    );
  }

  dynamic buildButtons(DocumentSnapshot document, FirebaseUser user) {
    bool owner = (document.data['originator'] == user.displayName);
    bool isJoined = (document.data['joinedUsers']
            .where((element) => element['name'] == user.displayName).length >
        0);
    bool belongs = (isJoined || owner);
    bool slotAvailable = (document.data['joinedUsers'].length <
        int.parse(document.data['teamMembers']));
    if (!belongs) {
      if (slotAvailable == true) {
        return buildJoinButton(document);
      } else {
        return FlatButton(
          child: Text(
            "The team is full.",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onPressed: null,
        );
      }
    } else if (owner) {
      return FlatButton(
        child: Text(
          "You cannot join your own project!",
          style: TextStyle(fontSize: 18, color: Constants.cancelButtonColor),
        ),
        onPressed: null,
      );
    } else if (belongs) {
      return buildLeaveButton(document);
    }
  }

  FlatButton buildJoinButton(DocumentSnapshot document) {
    return FlatButton(
      color: Constants.acceptButtonColor,
      child: Text("Join Project", style: TextStyle(fontSize: 15)),
      onPressed: () {
        _showSpecializationChooser(document);
      },
    );
  }

  FlatButton buildLeaveButton(DocumentSnapshot document) {
    return FlatButton(
      color: Constants.cancelButtonColor,
      child: Text(
        'Leave Project',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
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
        DocumentSnapshot currentJoinedUsers = await thisProject.get();
        dynamic without = currentJoinedUsers.data['joinedUsers']
            .where((element) => element['name'] != _user.displayName);

        thisProject.updateData({'joinedUsers': without.toList()});
        userDocument.updateData({
          'joinedProjects': FieldValue.arrayRemove([
            document.documentID,
          ])
        }).then((onValue) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Home', (Route<dynamic> route) => false);
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
        });
      },
    );
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
                buildJoinConfirm(document),
              ],
            ),
          );
        });
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
          'joinedUsers': FieldValue.arrayUnion([
            {'name': _user.displayName, 'specialization': _specialization}
          ])
        });
        userDocument.updateData({
          'joinedProjects': FieldValue.arrayUnion([
            document.documentID,
          ])
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
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
}
