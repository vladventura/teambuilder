import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:teambuilder/database/dbmanager.dart';
import 'package:teambuilder/models/project.dart';

// Constant values and texts
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';

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
    complexities.addAll(Texts.complexities);
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
                  margin: Constants.form_column_margins,
                  width: MediaQuery.of(context).size.width * Constants.project_name_screen_percent, // Reactive screen size
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.go,
                    autocorrect: Constants.has_autocorrect,
                    onSaved: (name) {
                      this.name = name;
                    },
                    validator: (name) {
                      if (name.isEmpty) return Texts.name_error_msg;
                    },
                    decoration: Constants.formDecoration(Texts.project_name)
                  ),
                ),
                Container(
                  margin: Constants.form_column_margins,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    maxLines: Constants.description_max_lines,
                    maxLength: Constants.description_max_length,
                    maxLengthEnforced: Constants.max_length_enforced,
                    autocorrect: Constants.has_autocorrect,
                    validator: (description) {
                      if (description.isEmpty) return Texts.description_error;
                    },
                    onSaved: (description) => this.description = description,
                    // TODO: Make the lines take a certain amount of characters
                    decoration: Constants.formDecoration(Texts.project_description)
                  ),
                ),
                Container(
                    margin: Constants.form_column_margins,
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
