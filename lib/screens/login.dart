import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teambuilder/database/validators.dart';
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

  bool validate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<String> submit() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (validate()) {
      if (_formType == FormType.login) {
        try {
          var username;
          await auth
              .signInWithEmailAndPassword(email: _email, password: _password)
              .then((user) {
            username = user.displayName;
            print(username);
            Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route <dynamic> route) => false);
            return null;
          });
          print(username);
          return username;
        } catch (e) {
          print(e.message);
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
        // Password
        TextFormField(
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
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: RaisedButton(
              onPressed: () {
                submit();
                showFlushbar(context, _username);
                Navigator.of(context).pushNamedAndRemoveUntil(
                '/Home', (Route<dynamic> route) => false);
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
