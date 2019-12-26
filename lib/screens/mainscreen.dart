import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './displayprojects.dart';
import './displayform.dart';

import 'package:teambuilder/util/constants.dart';

///Landing page of the Application
///
///It contains most of the graphical interfacing we're doing with users.
///[toQuery] and [projectsTitle] need an initial value so their respective Widgets
///can render properly. All of the [Controller]s are there to manage the transitions and
///animations between pages.
class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseUser _user;
  Stream<QuerySnapshot> toQuery =
      Firestore.instance.collection('projects').snapshots();
  String projectsTitle = "Join Projects";
  String screenToDisplay;

  @override
  void initState() {
    screenToDisplay = 'main';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> loadUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: this.loadUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.hasData) {
              _user = snapshot.data;
              return new Scaffold(
                resizeToAvoidBottomInset: true,
                resizeToAvoidBottomPadding: false,
                backgroundColor: Constants.mainBackgroundColor,
                drawer: this.buildDrawer(),
                appBar: this.buildAppBar(),
                body: this.buildScreen(screenToDisplay),
              );
            }
          }
          return new Container(child: new CircularProgressIndicator());
        });
  }

  /// This is what actually displays stuff on the screen with
  Widget buildScreen(String screen) {
    switch (screen) {
      case 'create':
        return DisplayForm();
      case 'main':
      default:
        return DisplayProjects(this.toQuery);
    }
  }

  /// Returns an App Bar widget that has a dynamic title determined by ```projectsTitle```
  AppBar buildAppBar() {
    return new AppBar(
      backgroundColor: Constants.sideBackgroundColor,
      iconTheme: new IconThemeData(
        color: Constants.flavorTextColor,
      ),
      textTheme: new TextTheme(
        title: new TextStyle(
          color: Constants.generalTextColor,
          fontSize: 20,
        ),
      ),
      title: new Text(projectsTitle),
    );
  }

  /// Hamburger menu with minimal styling.
  ///
  /// Contains the buttons that manipulate ```screenToDisplay``` and ```toQuery``` so we can
  /// change the displayed screen accordingly.
  Drawer buildDrawer() {
    return new Drawer(
      child: Container(
        color: Constants.mainBackgroundColor,
        width: MediaQuery.of(context).size.width,
        child: new ListView(
          physics: new BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountEmail: new Text(_user.email),
              accountName: new Text(_user.displayName),
              decoration: new ShapeDecoration(
                  shape: new Border.all(),
                  color: Constants.sideBackgroundColor),
            ),
            new ListTile(
              title: new Text(
                "All Projects",
                style: TextStyle(color: Constants.generalTextColor),
              ),
              onTap: () {
                setState(() {
                  toQuery =
                      Firestore.instance.collection('projects').snapshots();
                  projectsTitle = "Join Projects";
                });
                Navigator.pop(context);
              },
            ),
            new ListTile(
              title: new Text(
                "Own Projects",
                style: TextStyle(color: Constants.generalTextColor),
              ),
              onTap: () {
                setState(() {
                  toQuery = Firestore.instance
                      .collection('projects')
                      .where('originator', isEqualTo: _user.displayName)
                      .snapshots();
                  screenToDisplay = 'main';
                  projectsTitle = "Own Projects";
                });
                Navigator.pop(context);
              },
            ),
            new ListTile(
              title: Text(
                "Joined Projects",
                style: TextStyle(color: Constants.generalTextColor),
              ),
              onTap: () {
                setState(() {
                  toQuery = Firestore.instance
                      .collection('projects')
                      .where('joinedUserNames',
                          arrayContains: _user.displayName)
                      .snapshots();
                  screenToDisplay = 'main';
                  projectsTitle = "Joined Projects";
                });
                Navigator.of(context).pop();
              },
            ),
            new ListTile(
              title: new Text(
                "Create Project",
                style: new TextStyle(color: Constants.generalTextColor),
              ),
              onTap: () {
                setState(() {
                  screenToDisplay = 'create';
                  projectsTitle = "Create Project";
                });
                Navigator.of(context).pop();
              },
            ),
            new ListTile(
              title: new Text(
                "Sign out",
                style: TextStyle(color: Constants.generalTextColor),
              ),
              onTap: () async {
                try {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
