import 'package:flutter/material.dart';
import 'package:teambuilder/usable/displayform.dart';
import 'package:teambuilder/usable/displayteams.dart';
import 'package:teambuilder/util/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      title: 'Pepega',
      home: MyHomepage(),
    );
  }
}


class MyHomepage extends StatefulWidget{
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> with SingleTickerProviderStateMixin {
  bool show = false;
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _tabController.addListener(listener);
  }

  void listener(){
    if (_tabController.index == 0){
      show = false;
    }
    else {
      show = true;
    }
    setState(() {});
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Constants.third_color,
        body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool isScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Constants.main_color,
                  brightness: Brightness.dark,
                    title: Text('Main Screen'),
                    forceElevated: isScrolled,
                    pinned: true,
                    floating: true,
                    bottom: TabBar(
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                            text: 'Join Project',
                            icon: Icon(Icons.search)
                        ),
                        Tab(
                            text: 'Create Project',
                            icon: Icon(Icons.laptop)
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
                DisplayForm()
              ],
            )
        )
    );
  }
}