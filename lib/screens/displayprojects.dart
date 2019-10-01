library project;

import 'package:connectivity/connectivity.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/connectionstream.dart';
part 'package:teambuilder/screens/displayproject.dart';

class DisplayProjects extends StatefulWidget {
  _DisplayProjectsState createState() => _DisplayProjectsState();
}

class _DisplayProjectsState extends State<DisplayProjects> {
  final _db = Firestore.instance;
  Map _connectionSource = {ConnectivityResult.none: false};
  ConnectionStream _connectionStream = ConnectionStream.instance;

  @override
  void initState() {
    super.initState();
    _connectionStream.initialize();
    _connectionStream.stream.listen((source) {
      setState(() {
       _connectionSource = source; 
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            //TODO: Check the network here
            switch (_connectionSource.keys.toList()[0]) {
              case ConnectivityResult.mobile:
              case ConnectivityResult.wifi:
                FirebaseUser user = await FirebaseAuth.instance.currentUser();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        _DisplayProject(document: document, user: user)));
                break;
              case ConnectivityResult.none:
                showFlash(
                    context: context,
                    duration: new Duration(seconds: 3),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: FlashBar(
                          message: Text(
                            "No Internet Connection Detected",
                            style: TextStyle(
                              color: Constants.generalTextColor,
                            ),
                          ),
                        ),
                      );
                    });
                break;
            }
          },
        ),
      ),
    );
  }
}
