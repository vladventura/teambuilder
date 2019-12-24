import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './displayprojects.dart';
import './displayform.dart';

import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';

class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  PageController _pageController;
  FirebaseUser _user;
  int _currentIndex = 0;
  Stream<QuerySnapshot> toQuery;
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
              //Check for the connection here, and if it is not connected then Flash a message, and return "You're offline buddy"
              return new Scaffold(
                resizeToAvoidBottomInset: true,
                resizeToAvoidBottomPadding: false,
                backgroundColor: Constants.mainBackgroundColor,
                drawer: this.buildDrawer(),
                bottomNavigationBar: new BottomNavigationBar(
                  backgroundColor: Constants.sideBackgroundColor,
                  selectedItemColor: Constants.formActiveColor,
                  showSelectedLabels: false,
                  items: this.buildBottomNavBarItems(),
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: new Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
                body: new NestedScrollView(
                  physics: new BouncingScrollPhysics(),
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool isScrolled) {
                    return <Widget>[
                      this.buildSliverAppBar(isScrolled),
                    ];
                  },
                  body: this.buildPageView(),
                ),
              );
            } // snapshot.hasData
          } // snapshot != null
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

  SliverAppBar buildSliverAppBar(bool isScrolled) {
    return new SliverAppBar(
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
      forceElevated: isScrolled,
      pinned: isScrolled,
      floating: true,
    );
  }

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

  TabBarView buildTabBarView() {
    return new TabBarView(
      controller: _tabController,
      children: <Widget>[
        new DisplayProjects(toQuery),
        new DisplayForm(),
      ],
    );
  }

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

  SafeArea buildDrawer() {
    return SafeArea(
      child: new Drawer(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new FlatButton(
                child: new Text("All Projects"),
                onPressed: () {
                  setState(() {
                    toQuery =
                        Firestore.instance.collection('projects').snapshots();
                    projectsTitle = "Join Projects";
                  });
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Own Projects"),
                onPressed: () {
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
              new FlatButton(
                child: new Text("Sign out"),
                onPressed: () async {
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
      ),
    );
  }
}
