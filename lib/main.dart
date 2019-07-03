import 'package:flutter/material.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/usable/displayform.dart';
import 'package:teambuilder/usable/displayteams.dart';
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "${Texts.app_title} ${Texts.release}",
      home: MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage>
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
                        Tab(text: Constants.join_project['text'], icon: Constants.join_project['icon']),
                        Tab(text: Constants.create_project['text'], icon: Constants.create_project['icon'])
                      ],
                    ))
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[DisplayTeams(), DisplayForm()],
            )));
  }
  restartDatabase(){
    return FloatingActionButton(
      child: Icon(Icons.delete),
      onPressed: (){
        var dbLink = DBManager();
        dbLink.deleteProjects();
        setState(() {
         DisplayTeams(); 
        });
      },
    );
  }
}

