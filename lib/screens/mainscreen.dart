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
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: Constants.app_tabs,
      vsync: this,
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose(){
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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
              return Scaffold(
                resizeToAvoidBottomInset: false,
                resizeToAvoidBottomPadding: false,
                backgroundColor: Colors.blueAccent,
                drawer: buildDrawer(),
                body: NestedScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool isScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.deepOrangeAccent,
                        title: Texts.appbar_title,
                        forceElevated: isScrolled,
                        pinned: true,
                        floating: true,
                        bottom: TabBar(
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
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
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



  Drawer buildDrawer(){
    return Drawer(
      child: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text("Sign out, ${_user.displayName}"),
              onPressed: () {
                try {
                  FirebaseAuth.instance.signOut().then((empty) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                  });
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