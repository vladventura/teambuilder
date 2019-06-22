import 'package:flutter/material.dart';
import 'package:teambuilder/usable/displayteams.dart';
import 'package:teambuilder/util/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      title: 'Pepega',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomepage(),
    );
  }
}


class MyHomepage extends StatefulWidget{
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      backgroundColor: Constants.main_color,
        body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool isScrolled) {
              return <Widget>[
                SliverAppBar(
                    title: Text('Main Screen'),
                    forceElevated: isScrolled,
                    pinned: true,
                    floating: true,
                    bottom: TabBar(
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                            text: 'Join Project',
                            icon: Icon(Icons.home)
                        ),
                        Tab(
                            text: 'Create Project',
                            icon: Icon(Icons.bluetooth_searching)
                        )
                      ],
                    )
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                DisplayTeams(),
                Text('Second Page')
              ],
            )
        )
    );
  }
}