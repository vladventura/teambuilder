// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:teambuilder/database/dbmanager.dart';
// import 'package:teambuilder/util/constants.dart';

// class DisplayTeams extends StatefulWidget {
//   _DisplayTeams createState() => _DisplayTeams();
// }

// class _DisplayTeams extends State<DisplayTeams> {

//   final _db = Firestore.instance;

//   @override
//   void initState() {
//     super.initState();
//   }
//   /* 
//   TODO: Have a set of icons that instanciate depending on the difficuty of the project
//   TODO: Sort the projects by several topics, like difficulty 
//     (if difficulty is like beginner then just make this project's value 1 or something. 
//     Again, these sort of functionalities are abstracted from the dev in cloud databases).
//   */
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getProjectsFromDB(),
//         builder: (context, snapshot) {
//           if (snapshot.data != null) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, index) {
//                   return SafeArea(
//                     minimum: EdgeInsets.all(3),
//                     child: Container(
//                       decoration: Constants.buttonDecoration(),
//                       child: FlatButton(
//                         child: buttonInfoDisplay(
//                             snapshot.data[index].name, snapshot.data[index].originator),
//                         onPressed: () {
//                           return showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   content:
//                                       Text(snapshot.data[index].description),
//                                   title: Text(snapshot.data[index].name),
//                                 );
//                               });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           }
//           return Container(
//             child: CircularProgressIndicator(),
//           );
//         });
//   }

//   getProjectsFromDB() async {
//     var dbLink = new DBManager();
//     return dbLink.getAllProjects();
//   }

//   buttonInfoDisplay(String name, String originator) {
//     return SizedBox(
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               name,
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               originator,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ));
//   }
// }
