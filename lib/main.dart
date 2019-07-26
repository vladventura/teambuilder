import 'package:flutter/material.dart';

import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/home.dart';

/* 
TODO: Set PRs for all the TODOs (:
TODO: Set a proper color scheme for the app, like a palette of something
TODO: Firebase integration
*/

void main() {
  runApp(MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Home': (context) => MainScreen(),
    },
    home: Login(),
  ));
}
