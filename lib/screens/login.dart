import 'package:flutter/material.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/models/user.dart';

class LoginScreen extends StatefulWidget{
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _formKey = new GlobalKey<FormState>();
  String username, email, password;
  @override
  void initState(){
    super.initState();
  }

  Widget build (BuildContext context){
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
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
            // Username
              TextFormField(
              onSaved: (username){
                this.username = username;
              },
              validator: (username){
                if (username.contains(' ')) return "Usernames must not contain spaces";
                if (username.isEmpty) return "Required Field.";
              },
              textInputAction: TextInputAction.next,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Username',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 8,),
            // Email
            TextFormField(
              onSaved: (email){
                this.email = email;
              },
              validator: (email){
                if (email.contains(' ')) return "Emails must not contain spaces";
                if (!email.contains('@')) return "This is not a valid email.";
                if (email.isEmpty) return "Required Field.";
              },
              textInputAction: TextInputAction.next,
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
              onSaved: (password){
                this.password = password;
              },
              validator: (password){
                if (password.contains(' ')) return "Passwords must not contain spaces.";
                if (password.isEmpty) return "Required field\n";
                if (password.length < 6) return "Passwords should be larger than 6 characters";
              },
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
                submitUser();
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
      ),
    );
  }
  void submitUser(){
    var dbLink = DBManager();
    if(this._formKey.currentState.validate()){
      _formKey.currentState.save();
    }
    else 
    return null;
    User user = new User();
    user.username = username;
    user.email = email;
    user.password = password;
    dbLink.insertUser(user);
    Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route <dynamic> route) => false);
  }
}