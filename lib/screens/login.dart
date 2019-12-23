import 'dart:async';
import 'package:bad_words/bad_words.dart';
import 'package:connectivity/connectivity.dart';
import 'package:teambuilder/util/connectionstream.dart';

import './decorations.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';
import 'package:teambuilder/util/validators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Filter filter = new Filter();
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _username;
  bool _isTaken = false;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  FormType _formType = FormType.login;
  Map _connectionSource = {ConnectivityResult.none: false};
  ConnectionStream _connectionStream = ConnectionStream.instance;

  @override
  void initState() {
    super.initState();
    _connectionStream.initialize();
    _connectionStream.stream.listen((source) {
      if (this.mounted) {
        setState(() {
          _connectionSource = source;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      body: new Center(
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            physics: new BouncingScrollPhysics(),
            child: new Column(
              children: this.buildScreen(),
            ),
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

  void displayFlash(String message) {
    showFlash(
        context: context,
        duration: new Duration(seconds: 3),
        builder: (context, controller) {
          return new Flash(
            controller: controller,
            style: FlashStyle.grounded,
            backgroundColor: Constants.sideBackgroundColor,
            boxShadows: kElevationToShadow[4],
            child: new FlashBar(
              message: new Text(
                message,
                style: new TextStyle(
                  color: Constants.generalTextColor,
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> submit() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (_formType == FormType.register) {
      await isTaken();
    }
    if (validate()) {
      if (_formType == FormType.login) {
        try {
          await auth
              .signInWithEmailAndPassword(email: _email, password: _password)
              .then((nothing) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/Home', (Route<dynamic> route) => false);
          });
          return true;
        } catch (e) {
          //A switch statement here
          //And showFlash on each one of them
          //We can even extract the flash into it's own
          //separate function and pass in the context
          //and a string
          switch (e.code) {
            case "ERROR_USER_NOT_FOUND":
              print("Switch Reached");
              break;
            case "ERROR_USER_DISABLED":
              print("Switch Reached");
              break;
            case "ERROR_WRONG_PASSWORD":
              print("Switch Reached");
              break;
            case "ERROR_INVALID_EMAIL":
              print("Switch Reached");
              break;
            case "ERROR_TOO_MANY_REQUESTS":
              print("Switch Reached");
              break;
            case "ERROR_OPERATION_NOT_ALLOWED":
              print("Switch Reached");
              break;
          }
        }
      } else {
        try {
          UserUpdateInfo updater = new UserUpdateInfo();
          FirebaseUser user;
          await auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          user = await auth.currentUser();
          updater.displayName = _username;
          user.updateProfile(updater);
          await Firestore.instance
              .collection('users')
              .document(_username)
              .setData({
            'joinedProjects': [],
            'createdProjects': [],
          });
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
        } catch (e) {
          //Also switch statement here
          print(e);
        }
      }
    }
    return null;
  }

  void switchFormState(String state) {
    if (state == 'register') {
      setState(() {
        _formKey.currentState.reset();
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formKey.currentState.reset();
        _formType = FormType.login;
      });
    }
  }

  SafeArea buildTopText() {
    return new SafeArea(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            Texts.app_title,
            style: new TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.10,
              color: Constants.generalTextColor,
            ),
          ),
          new Text(
            Texts.flavor_text,
            style: new TextStyle(color: Constants.flavorTextColor),
          ),
        ],
      ),
    );
  }

  Padding buildEmailBox() {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextFormField(
          validator: EmailValidator.validate,
          style: Decorations.inputStyle(),
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: Decorations.loginBoxDecoration("Email"),
          onSaved: (email) {
            _email = email;
          }),
    );
  }

  isTaken() async {
    DocumentSnapshot snap = await Firestore.instance
        .collection('users')
        .document(this._usernameController.text)
        .get();
    setState(() {
      _isTaken = (snap.data != null);
    });
  }

  Padding buildUsernameBox() {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextFormField(
          validator: (value) {
            if (this._isTaken) return "Username is taken already";
            if (value.isEmpty) return "Username cannot be empty";
            if (filter.isProfane(value.replaceAll(new RegExp(r'\ '), '')))
              return "You cannot use these kind of words~!";
            return null;
          },
          style: Decorations.inputStyle(),
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: Decorations.loginBoxDecoration("Username"),
          controller: _usernameController,
          onSaved: (username) {
            _username = username;
          }),
    );
  }

  Padding buildPasswordBox() {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextFormField(
        style: Decorations.inputStyle(),
        controller: _passwordController,
        onSaved: (password) {
          _password = password;
        },
        validator: PasswordValidator.validate,
        obscureText: true,
        decoration: Decorations.loginBoxDecoration("Password"),
      ),
    );
  }

  Padding buildConfirmPasswordBox() {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextFormField(
        style: Decorations.inputStyle(),
        onSaved: (password) {
          _password = password;
        },
        validator: (confirm) {
          if (confirm != _passwordController.text)
            return "Passwords do not match";
          return null;
        },
        obscureText: true,
        decoration: Decorations.loginBoxDecoration("Confirm Password"),
      ),
    );
  }

  SizedBox buildLoginSubmitButton() {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,
      child: new RaisedButton(
          onPressed: () async {
            switch (_connectionSource.keys.toList()[0]) {
              case ConnectivityResult.wifi:
              case ConnectivityResult.mobile:
                displayFlash("Logging in...");
                await this.submit();
                break;
              case ConnectivityResult.none:
                displayFlash("No Internet Connection detected.");
                break;
            }
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20)),
          padding: new EdgeInsets.all(12),
          color: Colors.amber,
          child: new Text(
            'Log In',
            style: new TextStyle(color: Colors.black),
          )),
    );
  }

  SizedBox buildCreateAccountSubmitButton() {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,
      child: new RaisedButton(
          onPressed: () async {
            switch (_connectionSource.keys.toList()[0]) {
              case ConnectivityResult.wifi:
              case ConnectivityResult.mobile:
                displayFlash("Creating Account...");
                await this.submit();
                break;
              case ConnectivityResult.none:
                displayFlash("No Internet Connection detected.");
                break;
            }
          },
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          padding: new EdgeInsets.all(12),
          color: Colors.amber,
          child: new Text(
            'Create Account',
            style: new TextStyle(color: Colors.black),
          )),
    );
  }

  FlatButton buildCreateAccountButton() {
    return new FlatButton(
      child: new Container(
        width: MediaQuery.of(context).size.width * 0.30,
        padding: new EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(color: Constants.flavorTextColor),
          ),
        ),
        child: new Text(
          "Create Account",
          style: new TextStyle(color: Constants.flavorTextColor),
        ),
      ),
      onPressed: () {
        setState(() {
          _email = "";
          _password = "";
          _passwordController.text = "";
        });
        this.switchFormState('register');
      },
    );
  }

  FlatButton buildLoginButton() {
    return new FlatButton(
      child: new Container(
        width: MediaQuery.of(context).size.width * 0.30,
        padding: new EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(color: Constants.flavorTextColor),
          ),
        ),
        child: new Text(
          "Log into Account",
          style: new TextStyle(color: Constants.flavorTextColor),
        ),
      ),
      onPressed: () {
        setState(() {
          _email = "";
          _password = "";
          _passwordController.text = "";
        });
        this.switchFormState('login');
      },
    );
  }

  List<Widget> buildScreen() {
    if (_formType == FormType.login) {
      return [
        this.buildTopText(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
        ),
        this.buildEmailBox(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        this.buildPasswordBox(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        this.buildLoginSubmitButton(),
        this.buildCreateAccountButton(),
      ];
      // Create account page
    } else {
      return [
        this.buildTopText(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
        ),
        this.buildEmailBox(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        this.buildUsernameBox(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        this.buildPasswordBox(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        this.buildConfirmPasswordBox(),
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        this.buildCreateAccountSubmitButton(),
        this.buildLoginButton(),
      ];
    }
  }
}
