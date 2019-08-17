import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
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
          Text(Texts.flavor_text, style: TextStyle(color: Constants.flavorTextColor),),
        ],
      ),
    );
  }

  Padding buildEmailBox() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextFormField(
          validator: EmailValidator.validate,
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: Decorations.emailBoxDecoration(),
          onSaved: (email) {
            _email = email;
          }),
    );
  }

  Padding buildUsernameBox() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
          validator: UsernameValidator.validate,
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: Decorations.usernameBoxDecoration(),
          onSaved: (username) {
            _username = username;
          }),
    );
  }

  Padding buildPasswordBox() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextFormField(
        controller: _passwordController,
        onSaved: (password) {
          _password = password;
        },
        validator: PasswordValidator.validate,
        obscureText: true,
        decoration: Decorations.passwordBoxDecoration(),
      ),
    );
  }

  Padding buildConfirmPasswordBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        onSaved: (password) {
          _password = password;
        },
        validator: (confirm) {
          if (confirm != _passwordController.text)
            return "Passwords do not match";
          return null;
        },
        obscureText: true,
        decoration: Decorations.confirmPasswordBoxDecoration(),
      ),
    );
  }

  SizedBox buildLoginSubmitButton() {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,
      child: new RaisedButton(
          onPressed: () async {
            await submit();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(12),
          color: Colors.amber,
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

    SizedBox buildCreateAccountSubmitButton() {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,
      child: new RaisedButton(
          onPressed: () async {
            await submit();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(12),
          color: Colors.amber,
          child: Text(
            'Create Account',
            style: TextStyle(color: Colors.white),
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

  showFlushbar(BuildContext context, argument) {
    return Flushbar(
      message: 'Logging $argument in',
    ).show(context);
  }
}
