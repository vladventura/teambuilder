import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:teambuilder/models/project.dart';
// Constant values and texts
import 'package:teambuilder/util/constants.dart';
import 'package:teambuilder/util/texts.dart';
import 'package:teambuilder/util/validators.dart';
import 'package:flash/flash.dart';

class DisplayForm extends StatefulWidget {
  @override
  _DisplayFormState createState() => _DisplayFormState();
}

class _DisplayFormState extends State<DisplayForm> {
  String _complexity, _name, _description, _contactPlatforms;
  List<String> complexities = new List<String>();
  List<Widget> _textboxes = new List<Widget>();
  List<String> _textboxesData = new List<String>();
  List<Widget> _techTextboxes = new List<Widget>();
  List<String> _techTextboxesData = new List<String>();
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
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          buildNameBox(),
          buildDescriptionBox(),
          buildComplexityDropdow(),
          buildLanguagesDTB(),
          buildTechDTB(),
          buildTeamSizeInput(),
          buildSubmitButton(),
        ],
      ),
    );
  }

  Column buildLanguagesDTB() {
    return Column(
      children: <Widget>[
        OutlineButton(
          onPressed: generateTextBox,
          borderSide: BorderSide(
            color: Constants.formInactiveColor,
          ),
          highlightedBorderColor: Constants.formActiveColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Add Programming Languages",
                  style: TextStyle(
                    color: Constants.generalTextColor,
                  ),
                ),
                Icon(Icons.add)
              ],
            ),
          ),
        ),
        Column(
          children: _textboxes,
        ),
      ],
    );
  }

  Column buildTechDTB() {
    return Column(
      children: <Widget>[
        OutlineButton(
          onPressed: generateTechTextBox,
          borderSide: BorderSide(
            color: Constants.formInactiveColor,
          ),
          highlightedBorderColor: Constants.formActiveColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Add Frameworks, SDKs or Tools",
                  style: TextStyle(
                    color: Constants.generalTextColor,
                  ),
                ),
                Icon(Icons.add)
              ],
            ),
          ),
        ),
        Column(
          children: _techTextboxes,
        ),
      ],
    );
  }

  void generateTextBox() {
    setState(() {
      TextEditingController _textboxesController = new TextEditingController();
      _textboxes = List.from(_textboxes)
        ..add(
          new TextFormField(
            onSaved: (String value) {
              _textboxesData.add(_textboxesController.text);
            },
            validator: (String value) {
              if (value.isEmpty)
                return "Please add a Language or delete this box!";
              return null;
            },
            style: Constants.formContentStyle(),
            controller: _textboxesController,
            decoration: Constants.dynamicFormDecoration(
                "Language Used",
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _textboxesController.text = "";
                      _textboxes.removeLast();
                    });
                  },
                )),
          ),
        );
    });
  }

  void generateTechTextBox() {
    setState(() {
      TextEditingController _techTextboxesController =
          new TextEditingController();
      _techTextboxes = List.from(_techTextboxes)
        ..add(
          new TextFormField(
            onSaved: (String value) {
              _techTextboxesData.add(_techTextboxesController.text);
            },
            validator: (String value) {
              if (value.isEmpty)
                return "Please add a Technology or remove this box!";
              return null;
            },
            style: Constants.formContentStyle(),
            controller: _techTextboxesController,
            decoration: Constants.dynamicFormDecoration(
                "Technology Used",
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _techTextboxesController.text = "";
                      _techTextboxes.removeLast();
                    });
                  },
                )),
          ),
        );
    });
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
        style: Constants.formContentStyle(),
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
          style: Constants.formContentStyle(),
          validator: ProjectDescriptionValidator.validate,
          onSaved: (description) => this._description = description,
          decoration: Constants.formDecoration(Texts.project_description)),
    );
  }

  Row buildTeamSizeInput(){
    return Row(
        children: <Widget>[
          Text(
            "Number of Team Members ",
            style: TextStyle(
              color: Constants.generalTextColor,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.06,
            margin: EdgeInsets.all(3),
            padding: EdgeInsets.all(7),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: Constants.formContentStyle(),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: Constants.formDecoration(''),

            ),
          ),
        ],
    );
  }

  Container buildComplexityDropdow() {
    return Container(
        margin: Constants.form_column_margins,
        padding: Constants.complexity_padding,
        decoration: Constants.complexitiesDecoration(),
        child: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Constants.sideBackgroundColor),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  style: TextStyle(color: Constants.flavorTextColor),
                  hint: Text(
                    "Complexity",
                    style: TextStyle(color: Constants.generalTextColor),
                  ),
                  value: _complexity,
                  onChanged: (String value) => _onChanged(value),
                  items: complexities.map((String value) {
                    return new DropdownMenuItem(
                        value: value, child: Text(value));
                  }).toList())),
        ));
  }

  Container buildSubmitButton() {
    return Container(
        margin: Constants.complexity_padding,
        child: Center(
            child: FlatButton(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Text('Add Project'),
              Icon(Icons.add),
            ],
          ),
          textColor: Constants.acceptButtonColor,
          onPressed: (() async {
            showFlash(
                context: context,
                duration: Duration(seconds: 1),
                builder: (context, controller) {
                  return Flash(
                    controller: controller,
                    style: FlashStyle.grounded,
                    backgroundColor: Constants.sideBackgroundColor,
                    boxShadows: kElevationToShadow[4],
                    child: FlashBar(
                      message: Text(
                        "Creating project...",
                        style: TextStyle(
                          color: Constants.generalTextColor,
                        ),
                      ),
                    ),
                  );
                });
            submitProject();
          }),
        )));
  }

  void submitProject() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseUser _user = await _auth.currentUser();
      CollectionReference projects = db.collection('projects');
      Project project = new Project(
        _complexity,
        _contactPlatforms,
        _description,
        _name,
        [],
        _user.displayName,
        _textboxesData,
        _techTextboxesData,
      );
      setState(() {
        _textboxesData = new List<String>();
        _textboxes = new List<Widget>();
        _techTextboxes = new List<Widget>();
        _techTextboxesData = new List<String>();
      });
      CollectionReference users = db.collection('users');
      DocumentReference createdProject = await projects.add(project.toMap());
      DocumentReference userDocument = users.document(_user.displayName);
      userDocument.updateData({
        'createdProjects': FieldValue.arrayUnion([createdProject.documentID]),
      });
      showFlash(
          context: context,
          duration: Duration(seconds: 1),
          builder: (context, controller) {
            return Flash(
              controller: controller,
              style: FlashStyle.grounded,
              backgroundColor: Constants.sideBackgroundColor,
              boxShadows: kElevationToShadow[4],
              child: FlashBar(
                message: Text(
                  "Project created!",
                  style: TextStyle(
                    color: Constants.generalTextColor,
                  ),
                ),
              ),
            );
          });
    }
  }
}
