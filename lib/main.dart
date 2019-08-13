import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/mainscreen.dart';

/* 
TODO: Set issues for all the TODOs (:
TODO: Set a proper color scheme for the app, like a palette of something
*/

void main() {
  final _auth = FirebaseAuth.instance;
  runApp(MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Home': (context) => MainScreen(),
      '/Login': (context) => Login(),
    },
    home: FutureBuilder<FirebaseUser>(
      future: _auth.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if(snapshot.hasData){
          return MainScreen();
        } else {
          return Login();
        }
      },
    ),
  ));
}
