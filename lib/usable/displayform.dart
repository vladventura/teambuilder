import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/models/project.dart';
import 'package:teambuilder/util/constants.dart';

class DisplayForm extends StatefulWidget {
  @override
  _DisplayFormState createState() => _DisplayFormState();
}

class _DisplayFormState extends State<DisplayForm> {
  // This is to display and get the value from the
  // Dropdown list
  String _complexity;
  List<String> complexities = new List<String>();
  // This is to handle the data from the form
  String name, description, contactPlatforms;
  // This is a needed key. The main scaffold also needs one
  final _formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    complexities.addAll(['Beginner', 'Intermediate', 'Expert']);
  }

  void _onChanged(String value) {
    setState(() {
      _complexity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: 300,
                  padding: EdgeInsets.only(bottom: 5),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.go,
                    autocorrect: true,
                    autovalidate: true,
                    onSaved: (name) {
                      this.name = name;
                    },
                    validator: (name) {
                      if (name.isEmpty) return 'Please fill in a Project name';
                    },
                    decoration: InputDecoration(
                      // TODO: Move this code to another place to only write once
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Constants.main_color, width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Constants.side_color, width: 2.0)),
                      labelText: 'Project Name',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: TextFormField(
                    maxLines: 5,
                    maxLength: 500,
                    maxLengthEnforced: true,
                    autocorrect: true,
                    autovalidate: true,
                    validator: (description) {
                      if (description.isEmpty) {
                        return 'Please fill in a description!';
                      }
                    },
                    onSaved: (description) => this.description = description,
                    // TODO: Make the lines take a certain amount of characters
                    decoration: InputDecoration(
                      labelText: 'Project Description',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Constants.main_color, width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Constants.side_color, width: 2.0)),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border:
                            Border.all(color: Constants.side_color, width: 2)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            hint: Text('Complexity'),
                            value: _complexity,
                            onChanged: (String value) {
                              _onChanged(value);
                            },
                            items: complexities.map((String value) {
                              return new DropdownMenuItem(
                                  value: value, child: Text(value));
                            }).toList()))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                        child: FlatButton(
                      color: Colors.transparent,
                      child: Icon(Icons.add),
                      onPressed: (() {
                        submitProject();
                      }),
                    )))
              ],
            )));
  }

  void submitProject() {
    var dbLink = DBManager();
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else
      return null;
    Project project = new Project();
    project.name = name;
    project.description = description;
    project.complexity = _complexity;
    dbLink.insertProject(project);
  }
}
