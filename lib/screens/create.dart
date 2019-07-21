import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateScreen extends StatefulWidget{
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>{
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _username, _email, _password;
  
  @override
  void initState(){
    super.initState();
  }
  /*
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
              controller: _username,
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
            // Email
            TextFormField(
              controller: _email,
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
              controller: _password,
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
                if (confirm != _password.text) return "Passwords don't match.";
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
                onPressed: () async {
                  if (_formKey.currentState.validate()){
                    _registerUser();
                  }
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
  void _registerUser() async{
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
    
  }
}