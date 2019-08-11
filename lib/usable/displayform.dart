import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Constant values and texts
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';
import 'package:teambuilder/util/validators.dart';

class DisplayForm extends StatefulWidget {
  @override
  _DisplayFormState createState() => _DisplayFormState();
}

class _DisplayFormState extends State<DisplayForm> {
  FirebaseUser _user;
  String _complexity, _name, _description, _contactPlatforms;
  List<String> complexities = new List<String>();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    asyncSetup();
    complexities.addAll(Texts.complexities);
  }

  Future<dynamic> asyncSetup() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  void _onChanged(String value) {
    setState(() {
      _complexity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }

  Container buildNameBox() {
    return Container(
      margin: Constants.form_column_margins,
      width: MediaQuery.of(context).size.width *
          Constants.project_name_screen_percent,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        autocorrect: Constants.has_autocorrect,
        decoration: Constants.formDecoration(Texts.project_name),
        onSaved: (name) {
          this._name = name;
        },
        validator: ProjectNameValidator.validate,
      ),
    );
  }

  Container buildDescriptionBox() {
    return Container(
      margin: Constants.form_column_margins,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
          maxLines: Constants.description_max_lines,
          maxLength: Constants.description_max_length,
          maxLengthEnforced: Constants.max_length_enforced,
          autocorrect: Constants.has_autocorrect,
          validator: ProjectDescriptionValidator.validate,
          onSaved: (description) => this._description = description,
          decoration: Constants.formDecoration(Texts.project_description)),
    );
  }

  Container buildComplexityDropdow() {
    return Container(
        margin: Constants.form_column_margins,
        padding: Constants.complexity_padding,
        decoration: Constants.complexitiesDecoration(),
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
                hint: Texts.project_complexity_text,
                value: _complexity,
                onChanged: (String value) => _onChanged(value),
                items: complexities.map((String value) {
                  return new DropdownMenuItem(value: value, child: Text(value));
                }).toList())));
  }

  Container buildSubmitButton() {
    return Container(
        margin: Constants.complexity_padding,
        child: Center(
            child: FlatButton(
          color: Colors.transparent,
          child: Icon(Icons.add),
          onPressed: (() {
            //submitProject();
          }),
        )));
  }
}