import 'package:flutter/material.dart';
import 'package:teambuilder/util/constants.dart';

class Decorations {
  static InputDecoration emailBoxDecoration() {
    return new InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(
        color: Constants.generalTextColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20),
        borderSide: new BorderSide(
          color: Constants.formInactiveColor,
        ),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: new BorderSide(
          color: Constants.formActiveColor,
        ),
      ),
    );
  }


  static InputDecoration passwordBoxDecoration() {
    return new InputDecoration(
      labelText: 'Password',
      labelStyle: TextStyle(
        color: Constants.generalTextColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20),
        borderSide: new BorderSide(
          color: Constants.formInactiveColor,
        ),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: new BorderSide(
          color: Constants.formActiveColor,
        ),
      ),
    );
  }

  static InputDecoration usernameBoxDecoration() {
    return new InputDecoration(
      labelText: 'Username',
      labelStyle: TextStyle(
        color: Constants.generalTextColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20),
        borderSide: new BorderSide(
          color: Constants.formInactiveColor,
        ),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: new BorderSide(
          color: Constants.formActiveColor,
        ),
      ),
    );
  }
  static InputDecoration confirmPasswordBoxDecoration() {
    return new InputDecoration(
      labelText: 'Confirm Password',
      labelStyle: TextStyle(
        color: Constants.generalTextColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20),
        borderSide: new BorderSide(
          color: Constants.formInactiveColor,
        ),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: new BorderSide(
          color: Constants.formActiveColor,
        ),
      ),
    );
  }

  static TextStyle inputStyle(){
    return new TextStyle(
      color: Constants.flavorTextColor,
    );
  }
}
