import 'package:flutter/material.dart';

import 'package:teambuilder/database/dbmanager.dart';

class LoginScreen extends StatefulWidget{
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _formKey = new GlobalKey<FormState>();
  String username, password;
  @override
  void initState(){
    super.initState();
  }
  /*
  TODO: True login on the main page
  TODO: Find a way to return a user object to assign to this instance of the app so we can use the user's info
  TODO: Change that logo, it looks horrible btw

  Then, check if the database has a user with the specified username
  Then, check if the entry with this name matches the password entered
    Medium. This should be done server side; the user sends the credentials.
    Credentials must never ever EVER be checked client side; variables are stored in
    memory and this means that the user's password would also be stored in memory.
  Thus, an authenticate page that handles all this should be made.
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
              validator: (username){
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
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RaisedButton(
                onPressed: (){
                  loginUser();
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
                Navigator.of(context).pushNamed('/Create');
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  loginUser(){
    if(_formKey.currentState.validate()) Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route <dynamic> route) => false);
  }

  checkUser(String username) async {
    var dbLink = new DBManager();
    await dbLink.authenticate(username, "username");
  }
}