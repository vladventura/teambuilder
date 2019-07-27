import 'package:flutter/material.dart';
import 'package:teambuilder/screens/futurebuilderhome.dart';

import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/home.dart';

/* 
TODO: Set issues for all the TODOs (:
TODO: Set a proper color scheme for the app, like a palette of something
*/

void main() {
  runApp(MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Home': (context) => FutureMainScreen(),
    },
    home: Login(),
  ));
}
