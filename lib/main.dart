import 'package:flutter/material.dart';
import 'package:teambuilder/database/auth.dart';

import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/home.dart';

import 'database/authprovider.dart';

/* 
TODO: Set PRs for all the TODOs (:
TODO: Set a proper color scheme for the app, like a palette of something
TODO: Firebase integration
*/

void main(){
  runApp(
    Provider(
    auth: Auth(),
    child: MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Home': (context) => MainScreen(),
    },
    home: Streamer(),
  )));
}

class Streamer extends StatelessWidget {
  /*
  TODO: True login on the main page
  TODO: Find a way to return a user object to assign to this instance of the app so we can use the user's info
  TODO: Change that logo, it looks horrible btw
  */
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool loggedIn = snapshot.hasData;
            return loggedIn ? MainScreen() : Login();
          }
          return CircularProgressIndicator();
        });
  }
}