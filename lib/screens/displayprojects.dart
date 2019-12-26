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

/// Module that builds a scrollable list of clickable objects.
///
/// It is built in a way that it can be used by not only the very main screen, but also the
/// subsequent screens with [toQuery]: we can pass a [Stream<QuerySnapshot>] and we'll be able to
/// construct several items if they have certain properties.
class DisplayProjects extends StatefulWidget {
  final Stream<QuerySnapshot> toQuery;
  const DisplayProjects(this.toQuery);
  _DisplayProjectsState createState() => new _DisplayProjectsState();
}

class _DisplayProjectsState extends State<DisplayProjects> {
  Map _connectionSource = {ConnectivityResult.none: false};
  ConnectionStream _connectionStream = ConnectionStream.instance;

  @override
  void initState() {
    super.initState();
    this._connectionStream.initialize();
    this._connectionStream.stream.listen((source) {
      if (this.mounted) {
        setState(() {
          _connectionSource = source;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// The stream here would be the parent class' stream ([toQuery]).
  Widget build(BuildContext context) {
    return new Container(
      child: new StreamBuilder<QuerySnapshot>(
          stream: widget.toQuery,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView(
                physics: new BouncingScrollPhysics(),
                children: snapshot.data.documents.reversed
                    .map((document) => buildProject(document))
                    .toList(),
              );
            } else {
              return new CircularProgressIndicator();
            }
          }),
    );
  }

  /// Most of the online/offline checking is done when someone clicks on a project
  Card buildProject(DocumentSnapshot document) {
    return new Card(
      child: new Container(
        decoration: Constants.buttonDecoration(),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.95,
        height: (MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.10
            : MediaQuery.of(context).size.height * 0.07),
        child: new FlatButton(
          color: Constants.formInactiveColor,
          textColor: Constants.flavorTextColor,
          child: new Container(
            width: double.infinity,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  document.data['name'],
                  textAlign: TextAlign.center,
                ),
                new Text(
                  document.data['originator'],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          onPressed: () async {
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
                      return new Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: new FlashBar(
                          message: new Text(
                            "No Internet Connection Detected",
                            style: new TextStyle(
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
