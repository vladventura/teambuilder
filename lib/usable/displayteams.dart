import 'package:flutter/material.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/util/constants.dart';

class DisplayTeams extends StatefulWidget {
  _DisplayTeams createState() => _DisplayTeams();
}

class _DisplayTeams extends State<DisplayTeams> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProjectsFromDB(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return SafeArea(
                    minimum: EdgeInsets.all(3),
                    child: Container(
                      decoration: Constants.buttonDecoration(),
                      child: FlatButton(
                        child: buttonInfoDisplay(
                            snapshot.data[index].name, 'originator'),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      Text(snapshot.data[index].description),
                                  title: Text(snapshot.data[index].name),
                                );
                              });
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Container(
            child: CircularProgressIndicator(),
          );
        });
  }

  getProjectsFromDB() async {
    var dbLink = new DBManager();
    return dbLink.getAllProjects();
  }

  buttonInfoDisplay(String name, String originator) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
            ),
            Text(
              originator,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
