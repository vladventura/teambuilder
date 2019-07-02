import 'package:flutter/material.dart';
import 'package:teambuilder/util/constants.dart';

class JoinableTeam extends StatefulWidget {
  static String name;
  static String originator;

  @override
  _JoinableTeamState createState() => _JoinableTeamState();
}

class _JoinableTeamState extends State<JoinableTeam> {
  String name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.all(3),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: Constants.side_color,
                    width: 2,
                    style: BorderStyle.solid)),
            child: FlatButton(
                onPressed: () {
                  print('pressed');
                },
                child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          name,
                          textAlign: TextAlign.end,
                        ),
                        Text('Project Originator'),
                      ],
                    )))));
  }
}
