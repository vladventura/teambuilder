import 'package:flutter/material.dart';
import 'package:teambuilder/database/auth.dart';
import 'package:teambuilder/database/authprovider.dart';
import 'package:teambuilder/database/validators.dart';
import 'package:teambuilder/screens/home.dart';


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

  bool validate(){
    final form = _formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
          String userId =
              await auth.signWithEmailAndPassword(_email, _password);
          print("Signed in $userId");
        } else {
          String userId = await auth.createUserWithEmailAndPassword(_email, _password);
          print("Created $userId");
        }
      } catch (e) {
        print(e);
      }
    }
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
              onPressed: submit,
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
}
