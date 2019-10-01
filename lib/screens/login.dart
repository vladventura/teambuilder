import 'dart:async';
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
      setState(() {
        _connectionSource = source;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectionStream.disposeStream();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: buildScreen(),
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

  Future<dynamic> submit() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (_formType == FormType.register) {
      await isTaken();
    }
    if (validate()) {
      if (_formType == FormType.login) {
        try {
          await auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
          return true;
        } catch (e) {
          print(e);
        }
      } else {
        try {
          UserUpdateInfo updater = UserUpdateInfo();
          await Firestore.instance
              .collection('users')
              .document(_username)
              .setData({
            'joinedProjects': [],
            'createdProjects': [],
          });
          FirebaseUser user = await auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          updater.displayName = _username;
          await auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          user.updateProfile(updater);
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
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

  SafeArea buildTopText() {
    return new SafeArea(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Texts.app_title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.10,
              color: Constants.generalTextColor,
            ),
          ),
          Text(
            Texts.flavor_text,
            style: TextStyle(color: Constants.flavorTextColor),
          ),
        ],
      ),
    );
  }

  Padding buildEmailBox() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
          validator: (value) {
            if (this._isTaken) return "Username is taken already";
            if (value.isEmpty) return "Username cannot be empty";
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
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
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: FlashBar(
                          message: Text(
                            "Logging in...",
                            style: TextStyle(
                              color: Constants.generalTextColor,
                            ),
                          ),
                        ),
                      );
                    });
                await submit();
                break;
              case ConnectivityResult.none:
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: FlashBar(
                          message: Text(
                            "No Internet Connection Detected",
                            style: TextStyle(
                              color: Constants.generalTextColor,
                            ),
                          ),
                        ),
                      );
                    });
                break;
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(12),
          color: Colors.amber,
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.black),
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
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: FlashBar(
                          message: Text(
                            "Creating account...",
                            style: TextStyle(
                              color: Constants.generalTextColor,
                            ),
                          ),
                        ),
                      );
                    });
                await submit();
                break;
              case ConnectivityResult.none:
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: FlashBar(
                          message: Text(
                            "No Internet Connection Detected",
                            style: TextStyle(
                              color: Constants.generalTextColor,
                            ),
                          ),
                        ),
                      );
                    });
                break;
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(12),
          color: Colors.amber,
          child: Text(
            'Create Account',
            style: TextStyle(color: Colors.black),
          )),
    );
  }

  FlatButton buildCreateAccountButton() {
    return new FlatButton(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.30,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Constants.flavorTextColor),
          ),
        ),
        child: Text(
          "Create Account",
          style: TextStyle(color: Constants.flavorTextColor),
        ),
      ),
      onPressed: () {
        setState(() {
          _email = "";
          _password = "";
          _passwordController.text = "";
        });
        switchFormState('register');
      },
    );
  }

  FlatButton buildLoginButton() {
    return new FlatButton(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.30,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Constants.flavorTextColor),
          ),
        ),
        child: Text(
          "Log into Account",
          style: TextStyle(color: Constants.flavorTextColor),
        ),
      ),
      onPressed: () {
        setState(() {
          _email = "";
          _password = "";
          _passwordController.text = "";
        });
        switchFormState('login');
      },
    );
  }

  List<Widget> buildScreen() {
    if (_formType == FormType.login) {
      return [
        buildTopText(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
        ),
        buildEmailBox(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        buildPasswordBox(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        buildLoginSubmitButton(),
        buildCreateAccountButton(),
      ];
      // Create account page
    } else {
      return [
        buildTopText(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
        ),
        buildEmailBox(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        buildUsernameBox(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        buildPasswordBox(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        buildConfirmPasswordBox(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        buildCreateAccountSubmitButton(),
        buildLoginButton(),
      ];
    }
  }
}
