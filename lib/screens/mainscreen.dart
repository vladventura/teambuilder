import 'dart:async';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: Constants.app_tabs,
      vsync: this,
    );
    _scrollController = ScrollController();
    _pageController = new PageController();
    loadUser();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
  }

  Future<dynamic> loadUser() async {
    _user = await FirebaseAuth.instance.currentUser();
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.hasData) {
              //Check for the connection here, and if it is not connected then Flash a message, and return "You're offline buddy"
              return Scaffold(
                resizeToAvoidBottomInset: true,
                resizeToAvoidBottomPadding: false,
                backgroundColor: Constants.mainBackgroundColor,
                drawer: buildDrawer(),
                bottomNavigationBar: new BottomNavigationBar(
                  backgroundColor: Constants.sideBackgroundColor,
                  selectedItemColor: Constants.formActiveColor,
                  showSelectedLabels: false,
                  items: [
                    new BottomNavigationBarItem(
                      icon: Constants.join_project['icon'],
                      title: Text(Constants.join_project['text']),
                    ),
                    new BottomNavigationBarItem(
                      icon: Constants.create_project['icon'],
                      title: Text(Constants.create_project['text']),
                    )
                  ],
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
                body: NestedScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool isScrolled) {
                    return <Widget>[
                      SliverAppBar(
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
                        title: (_currentIndex == 0)
                            ? Texts.appbar_join_title
                            : Texts.appbar_create_title,
                        forceElevated: isScrolled,
                        pinned: isScrolled,
                        floating: true,
                      ),
                    ];
                  },
                  body: new PageView(
                    controller: _pageController,
                    onPageChanged: ((index) {
                      setState(() {
                        this._currentIndex = index;
                      });
                    }),
                    children: <Widget>[
                      DisplayProjects(),
                      DisplayForm(),
                    ],
                  ),
                ),
              );
            } // snapshot.hasData
          } // snapshot != null
          return Container(child: CircularProgressIndicator());
        });
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
        DisplayProjects(),
        DisplayForm(),
      ],
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        DisplayProjects(),
        DisplayForm(),
      ],
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: <Widget>[
        Tab(
            text: Constants.join_project['text'],
            icon: Constants.join_project['icon']),
        Tab(
          text: Constants.create_project['text'],
          icon: Constants.create_project['icon'],
        ),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text("Sign out, ${_user.displayName}"),
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
    );
  }
}
