import 'package:flutter/material.dart';
import 'package:teambuilder/usable/joinableteam.dart';

class DisplayTeams extends StatelessWidget{
  Widget build (BuildContext context){
    return ListView.builder(
          itemBuilder: (context, index) => Container(
            child: JoinableTeam()
    ),
      physics: BouncingScrollPhysics(),
      itemCount: 10,
    );
  }
}