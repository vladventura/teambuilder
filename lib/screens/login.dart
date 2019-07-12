import 'package:flutter/material.dart';

void main() => runApp(LoginScreen());


class LoginScreen extends StatefulWidget{
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  String email, password;
  @override
  void initState(){
    super.initState();
  }

  Widget build (BuildContext context){
    return MaterialApp(
      home: Scaffold(),
    );
  }

}