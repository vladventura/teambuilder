import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 48,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 38,
              ),
            ),
            SizedBox(height: 48.0,),
            // Email
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 8,),
            // Password
            TextFormField(
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RaisedButton(
                onPressed: (){
                //Validate first, then push this
                 Navigator.of(context).pushNamedAndRemoveUntil('/Start', (Route <dynamic> route) => false);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.amber,
                child: Text('Log In', style: TextStyle(color: Colors.white))
              ),
            ),
            FlatButton(
              child: Text('Create Account', style: TextStyle(color: Colors.black54),),
              onPressed: (){
              },
            ),
          ],
        ),
      ),
    );
  }
}