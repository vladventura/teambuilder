import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:teambuilder/screens/displayprojects.dart';
import 'package:teambuilder/usable/displayform.dart';

import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  FirebaseUser _user;

  @override
  void initState() async {
    super.initState();
    _user = await FirebaseAuth.instance.currentUser();
    _tabController = TabController(length: Constants.app_tabs, vsync: this);
    _scrollController = ScrollController();

  }

  //TODO: Keep an eye on this behavior and the StreamBuilder in main
  @override
  void dispose() async{
    await FirebaseAuth.instance.signOut();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //floatingActionButton: restartDatabase(),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.third_color,
        drawer: Drawer(
          child: Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text("Sign ${_user.displayName} out"),
                  onPressed: () async {
                    try{
                      FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route <dynamic> route) => false);
                    } catch (e){
                      print(e);
                    }
                  },
                )
              ],
            ),
          ),
        ),
        body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool isScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Constants.main_color,
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
                            icon: Constants.create_project['icon'])
                      ],
                    ))
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[DisplayProjects(), DisplayForm()],
            )));
  }

  // restartDatabase() {
  //   return FloatingActionButton(
  //     child: Icon(Icons.delete),
  //     onPressed: () {
  //       var dbLink = DBManager();
  //       dbLink.deleteProjects();
  //       setState(() {
  //         DisplayProjects();
  //       });
  //     },
  //   );
  // }
}
