import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teambuilder/screens/login.dart';
import 'package:teambuilder/screens/mainscreen.dart';

/* 
TODO: Sign user out after certain amount of time.
TODO: Docstrings for all functions. Should maybe do before the project gets out-of-hand big.
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final _auth = FirebaseAuth.instance;
  runApp(new MaterialApp(
    routes: <String, WidgetBuilder>{
      '/Login': (context) => new Login(),
      '/Home': (context) => new MainScreen(),
    },
    home: new FutureBuilder<FirebaseUser>(
      future: _auth.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          return new MainScreen();
        } else {
          return new Login();
        }
      },
    ),
  ));
}
