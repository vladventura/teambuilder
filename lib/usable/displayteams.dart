import 'package:flutter/material.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/util/constants.dart';

class DisplayTeams extends StatefulWidget{
  _DisplayTeams createState() => _DisplayTeams();
}

class _DisplayTeams extends State<DisplayTeams>{
  final controller_name = new TextEditingController();
  final controller_owner = new TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build (BuildContext context){
    return FutureBuilder(
      future: getProjectsFromDB(),
      builder:(context, snapshot) {
        if(snapshot.data != null){
          if (snapshot.hasData){
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return SafeArea(
                  minimum: EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Constants.side_color,
                        width: 2,
                        style: BorderStyle.solid
                      )
                    ),
                    child: FlatButton(
                      onPressed: (){
                        return showDialog(
                          context: context,
                          builder:(BuildContext context) {
                            return AlertDialog(
                            content: Text(snapshot.data[index].description),
                            title: Text(snapshot.data[index].name),
                          );
                          }
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(snapshot.data[index].name, textAlign: TextAlign.right,),
                            Text('Originator', textAlign: TextAlign.right,)
                          ],
                        ),
                      )
                    ),
                  ),
                );
              },
            );
          }
        }
        return new Container(
            child: CircularProgressIndicator(),
          );
      }
    );
  }

  getProjectsFromDB() async{
    var dbLink = new DBManager();
    return dbLink.getAllProjects();
  }
}