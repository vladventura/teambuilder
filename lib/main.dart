import 'package:flutter/material.dart';
import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/mainscreen.dart';


/* 
TODO: Set issues for all the TODOs (:
TODO: Set a proper color scheme for the app, like a palette of something
*/

void main() {
  runApp(MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Home': (context) => MainScreen(),
    },
    home: Login(),
  ));
}
