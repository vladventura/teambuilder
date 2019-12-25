import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './displayprojects.dart';
import './displayform.dart';

import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';

///Landing page of the Application
///
///It contains most of the graphical interfacing we're doing with users.
///[toQuery] and [projectsTitle] need an initial value so their respective Widgets
///can render properly. All of the [Controller]s are there to manage the transitions and
///animations between pages.
class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  PageController _pageController;
  int _currentIndex = 0;

  FirebaseUser _user;
  Stream<QuerySnapshot> toQuery =
      Firestore.instance.collection('projects').snapshots();
  String projectsTitle = "Join Projects";

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      length: Constants.app_tabs,
      vsync: this,
    );
    _scrollController = new ScrollController();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
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
                body: DisplayForm(),
              );
            }
          }
          return new Container(child: new CircularProgressIndicator());
        });
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      new BottomNavigationBarItem(
        icon: Constants.join_project['icon'],
        title: new Text(Constants.join_project['text']),
      ),
      new BottomNavigationBarItem(
        icon: Constants.create_project['icon'],
        title: new Text(Constants.create_project['text']),
      )
    ];
  }

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
      title: (_currentIndex == 0)
          ? Text(projectsTitle)
          : Texts.appbar_create_title,
    );
  }

  ///This is what displays the content of the tabs
  PageView buildPageView() {
    return new PageView(
      controller: _pageController,
      onPageChanged: ((index) {
        setState(() {
          this._currentIndex = index;
        });
      }),
      children: <Widget>[
        new DisplayProjects(toQuery),
        new DisplayForm(),
      ],
    );
  }

  /// Instead, this displays the **tabs themselves**
  ///
  /// Not to be confused with displaying the contents of the tab, this only
  /// shows the actual tabs themselves
  TabBar buildTabBar() {
    return new TabBar(
      controller: _tabController,
      tabs: <Widget>[
        new Tab(
            text: Constants.join_project['text'],
            icon: Constants.join_project['icon']),
        new Tab(
          text: Constants.create_project['text'],
          icon: Constants.create_project['icon'],
        ),
      ],
    );
  }

  /// Constructs the side menu for the application and its functionality.
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
