import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/exceptions/userex.dart';
import 'package:teambuilder/models/user.dart';

class CreateScreen extends StatefulWidget{
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>{
  final _formKey = new GlobalKey<FormState>();
  String username, email, password;
  @override
  void initState(){
    super.initState();
  }
  /*
  TODO: Make a new page to call from the create account button
  
  Then, check if the username and/or the email are already define in the database,
  because these two are Unique
    Medium. I'll probably have to split the transaction into several pieces and
    check for the username and the email
  
  This will prepare me to use Firebase, even though these features are abstracted
  on a cloud database (including authentication). If not, then I'll most likely 
  look for an oAuth package or something. This is too far ahead yet.
  */
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
                try {
                  checkUser(username);
                } on UserExeption {
                  return "This username is already taken";
                }
                if (username.contains(' ')) return "Usernames must not contain spaces";
                if (username.isEmpty) return "Required Field.";
                return null;
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
                return null;
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
                return null;
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
            SizedBox(height: 8),
            // Confirm Password
            TextFormField(
              validator: (confirm){
                if (confirm != this.password) return "Passwords don't match.";
                return null;
              },
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
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
                child: Text('Create Account', style: TextStyle(color: Colors.white))
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  checkUser(String username){
    var dbLink = new DBManager();
    try{
      dbLink.authenticate(username, "username");
    } on DatabaseException{
      throw new UserExeption('user');
    }
  }

  checkEmail(String email){
    var dbLink = new DBManager();
    try{
      dbLink.authenticate(email, "email");
    } on DatabaseException {
      throw new UserExeption('email');
    }
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