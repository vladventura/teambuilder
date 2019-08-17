import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teambuilder/decorations/loginform.dart';
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';
import 'package:teambuilder/util/validators.dart';
import 'package:flushbar/flushbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _username;
  TextEditingController _passwordController = new TextEditingController();
  FormType _formType = FormType.login;
  var displayMe;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            shrinkWrap: true,
            children: buildScreen(),
          ),
        ),
      ),
    );
  }

  bool validate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> submit() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (validate()) {
      if (_formType == FormType.login) {
        try {
          await auth
              .signInWithEmailAndPassword(email: _email, password: _password)
              .then((user) {
            displayMe = user.displayName;
            showFlushbar(context, displayMe);
            print(displayMe);
          });
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
          return true;
        } catch (e) {
          print(e);
        }
      } else {
        try {
          UserUpdateInfo updater = UserUpdateInfo();
          FirebaseUser user = await auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          updater.displayName = _username;
          print(updater.displayName);
          user.updateProfile(updater);
        } catch (e) {
          print(e.message);
        }
      }
    }
    return null;
  }

  void switchFormState(String state) {
    _formKey.currentState.reset();
    if (state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  Column buildTopText() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          Texts.app_title,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.10,
            color: Constants.generalTextColor,
          ),
        ),
        Text(Texts.flavor_text),
      ],
    );
  }

  TextFormField buildEmailBox() {
    return new TextFormField(
        validator: EmailValidator.validate,
        textInputAction: TextInputAction.next,
        autofocus: false,
        decoration: Decorations.emailBoxDecoration(),
        onSaved: (email) {
          _email = email;
        });
  }

  TextFormField buildPasswordBox(){
    return new TextFormField();
  }

  List<Widget> buildScreen() {
    if (_formType == FormType.login) {
      return [
        buildTopText(),
        SizedBox(
          height: 100,
        ),
        // Email
        buildEmailBox(),
        SizedBox(
          height: 8,
        ),
        // Password
        TextFormField(
          onSaved: (password) {
            _password = password;
          },
          validator: PasswordValidator.validate,
          obscureText: true,
          decoration: Decorations.passwordBoxDecoration(),
        ),
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: RaisedButton(
              onPressed: () async {
                await submit();
              },
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
          onPressed: () {
            switchFormState('register');
          },
        ),
      ];
      // Create account page
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
            validator: EmailValidator.validate,
            textInputAction: TextInputAction.next,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onSaved: (email) {
              _email = email;
            }),
        SizedBox(
          height: 8,
        ),
        // Username
        TextFormField(
            validator: UsernameValidator.validate,
            textInputAction: TextInputAction.next,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'User Name',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onSaved: (username) {
              _username = username;
            }),
        SizedBox(
          height: 8,
        ),
        // Password
        TextFormField(
          controller: _passwordController,
          onSaved: (password) {
            _password = password;
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
        // Confirm password with the value of the controller
        SizedBox(
          height: 8,
        ),
        // Password
        TextFormField(
          onSaved: (password) {
            _password = password;
          },
          validator: (confirm) {
            if (confirm != _passwordController.text)
              return "Passwords do not match";
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm Password',
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
              onPressed: submit,
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
          child: Text('Log In', style: TextStyle(color: Colors.black54)),
          onPressed: () {
            switchFormState('login');
          },
        ),
      ];
    }
  }

  showFlushbar(BuildContext context, argument) {
    Flushbar(
      message: 'Logging $argument in',
    ).show(context);
  }
}
