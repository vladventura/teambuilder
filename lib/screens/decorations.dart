import 'package:flutter/material.dart';
import 'package:teambuilder/util/constants.dart';

class Decorations {
  static InputDecoration loginBoxDecoration(String label) {
    return new InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Constants.generalTextColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      border: new OutlineInputBorder(
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
