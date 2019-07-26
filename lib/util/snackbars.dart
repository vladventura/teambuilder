import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

class Snacks {
  successfulCreateUser(BuildContext context, argument) {
    Flushbar(
      message: "Successfully created user $argument",
      duration: Duration(seconds: 3),
    ).show(context);
  }

  successfulLoginUser(BuildContext context, argument) {
    Flushbar(
      message: "Successfully logged $argument in",
      duration: Duration(seconds: 3),
    ).show(context);
  }

  creatingUser(BuildContext context, argument) {
    Flushbar(
      message: "Creating user $argument",
      duration: Duration(seconds: 3),
    ).show(context);
  }

  void loggingUser(BuildContext context, argument) {
    Flushbar(
      message: "Is $argument in",
      duration: Duration(seconds: 3),
    ).show(context);
  }
}
