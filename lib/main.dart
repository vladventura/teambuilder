import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/mainscreen.dart';

/* 
TODO: Sign user out after certain amount of time.
TODO: Handle 'User is Offline' case
TODO: Docstrings for all functions. Should maybe do before the project gets out-of-hand big.
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
