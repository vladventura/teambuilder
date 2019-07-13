import 'package:flutter/material.dart';

import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/home.dart';

void main(){
  runApp(MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Start': (context) => MyHomepage(),
    },
    home: LoginScreen(),
  ));
}