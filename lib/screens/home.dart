import 'package:flutter/material.dart';
import 'package:teambuilder/database/auth.dart';
import 'package:teambuilder/database/authprovider.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/usable/displayform.dart';
import 'package:teambuilder/usable/displayteams.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Constants.app_tabs, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: restartDatabase(),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.third_color,
        drawer: Drawer(
          child: Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text("Sign Out"),
                  onPressed: () async {
                    try{
                      Auth auth = Provider.of(context).auth;
                      print("Signed out ${auth.currentUser()}");
                      await auth.signOut();
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
              children: <Widget>[DisplayTeams(), DisplayForm()],
            )));
  }

  restartDatabase() {
    return FloatingActionButton(
      child: Icon(Icons.delete),
      onPressed: () {
        var dbLink = DBManager();
        dbLink.deleteProjects();
        setState(() {
          DisplayTeams();
        });
      },
    );
  }
}
