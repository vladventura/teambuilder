import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teambuilder/util/constants.dart';

class DisplayProjects extends StatefulWidget{
  _DisplayProjectsState createState() => _DisplayProjectsState();
}

class _DisplayProjectsState extends State<DisplayProjects>{
  final _db = Firestore.instance;
  
  @override
  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('projects').snapshots(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return Column(
            children: snapshot
                      .data
                      .documents
                      .map((document) => buildProject(document))
                      .toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }

  FlatButton buildProject(DocumentSnapshot document){
    return FlatButton(
      child: Container(
        decoration: Constants.buttonDecoration(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(document.data['name'], textAlign: TextAlign.center,),
              Text(document.data['originator'], textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
      onPressed: () {
        return showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              content: Text(document.data['description']),
              title: Text(document.data['name'] + ' by ' + document.data['originator']),
            );
          }
        );
      },
    );
  }
}