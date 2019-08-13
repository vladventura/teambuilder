import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teambuilder/models/project.dart';
// Constant values and texts
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';
import 'package:teambuilder/util/validators.dart';

class DisplayForm extends StatefulWidget {
  @override
  _DisplayFormState createState() => _DisplayFormState();
}

class _DisplayFormState extends State<DisplayForm> {
  String _complexity, _name, _description, _contactPlatforms;
  List<String> complexities = new List<String>();
  final _auth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();
  final db = Firestore.instance;

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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildNameBox(),
          buildDescriptionBox(),
          buildComplexityDropdow(),
          buildSubmitButton(),
        ],
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
          onPressed: (() async {
            submitProject();
          }),
        )));
  }

  void submitProject() async{
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      FirebaseUser _user = await _auth.currentUser();
      CollectionReference reference  = db.collection('projects');
      Project project = new Project(
        _user.uid, 
        _name, 
        _description, 
        _complexity, 
        _contactPlatforms, 
        _user.displayName
      );
      reference.add(project.toMap());
    }
  }
}