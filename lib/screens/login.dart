import 'package:flutter/material.dart';
import 'package:teambuilder/database/auth.dart';
import 'package:teambuilder/database/authprovider.dart';
import 'package:teambuilder/database/validators.dart';
import 'package:teambuilder/screens/home.dart';

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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  FormType _formType = FormType.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            children: buildScreen(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildScreen() {
    if (_formType == FormType.login) {
      return [
        CircleAvatar(
          backgroundColor: Colors.amber,
          radius: 48,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 38,
          ),
        ),
        SizedBox(
          height: 48.0,
        ),
        // Email
        TextFormField(
            validator: UsernameValidator.validate,
            textInputAction: TextInputAction.next,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onSaved: (value) {
              _email = value;
            }),
        SizedBox(
          height: 8,
        ),
        // Password
        TextFormField(
          onSaved: (value) {
            _password = value;
          },
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(12),
              color: Colors.amber,
              child: Text(
                'Log In',
                style: TextStyle(color: Colors.white),
              )),
        ),
        FlatButton(
          child:
              Text('Create Account', style: TextStyle(color: Colors.black54)),
          onPressed: () {},
        ),
      ];
    } else {
      return [
        CircleAvatar(
          backgroundColor: Colors.amber,
          radius: 48,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 38,
          ),
        ),
        SizedBox(
          height: 48.0,
        ),
        // Email
        TextFormField(
            validator: UsernameValidator.validate,
            textInputAction: TextInputAction.next,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onSaved: (value) {
              _email = value;
            }),
        SizedBox(
          height: 8,
        ),
        // Password
        TextFormField(
          onSaved: (value) {
            _password = value;
          },
          validator: PasswordValidator.validate,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(12),
              color: Colors.amber,
              child: Text(
                'Create Account',
                style: TextStyle(color: Colors.white),
              )),
        ),
        FlatButton(
          child:
              Text('Log In', style: TextStyle(color: Colors.black54)),
          onPressed: () {},
        ),
      ];
    }
  }
}
