import 'package:bad_words/bad_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:teambuilder/models/project.dart';
import 'package:teambuilder/util/connectionstream.dart';
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
  String _complexity, _name, _description, _teamMembers;
  Map<String, dynamic> _contactPlatforms = new Map<String, dynamic>();
  List<String> complexities = new List<String>();
  List<Widget> _textboxes = new List<Widget>();
  List<String> _textboxesData = new List<String>();
  List<Widget> _techTextboxes = new List<Widget>();
  List<String> _techTextboxesData = new List<String>();
  ConnectionStream _connectionStream = ConnectionStream.instance;
  Map _connectionSources = {ConnectivityResult.none: false};

  DateTime _time = new DateTime.now();
  DateTime _oneToThen = new DateTime.now();

  final _auth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();
  final db = Firestore.instance;
  final Filter filter = new Filter();

  @override
  void initState() {
    super.initState();
    complexities.addAll(Texts.complexities);
    _connectionStream.initialize();
    this._connectionStream.stream.listen((source) {
      if (this.mounted) {
        setState(() {
          _connectionSources = source;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _complexity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            this.buildNameBox(),
            this.buildDescriptionBox(),
            this.buildComplexityDropdow(),
            this.buildLanguagesDTB(),
            this.buildTechDTB(),
            this.buildTeamSizeInput(),
            this.buildEmailBox(),
            this.buildGithubBox(),
            this.buildDiscordUsernameBox(),
            this.buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Column buildLanguagesDTB() {
    return new Column(
      children: <Widget>[
        new OutlineButton(
          onPressed: generateTextBox,
          borderSide: new BorderSide(
            color: Constants.formInactiveColor,
          ),
          highlightedBorderColor: Constants.formActiveColor,
          child: new Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(20),
            ),
            child: new Column(
              children: <Widget>[
                new Text(
                  "Add Programming Languages",
                  style: new TextStyle(
                    color: Constants.generalTextColor,
                  ),
                ),
                new Icon(Icons.add)
              ],
            ),
          ),
        ),
        new Column(
          children: _textboxes,
        ),
      ],
    );
  }

  Column buildTechDTB() {
    return new Column(
      children: <Widget>[
        new OutlineButton(
          onPressed: generateTechTextBox,
          borderSide: new BorderSide(
            color: Constants.formInactiveColor,
          ),
          highlightedBorderColor: Constants.formActiveColor,
          child: new Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(20),
            ),
            child: new Column(
              children: <Widget>[
                new Text(
                  "Add Frameworks, SDKs or Tools",
                  style: new TextStyle(
                    color: Constants.generalTextColor,
                  ),
                ),
                new Icon(Icons.add)
              ],
            ),
          ),
        ),
        new Column(
          children: _techTextboxes,
        ),
      ],
    );
  }

  void generateTextBox() {
    setState(() {
      TextEditingController _textboxesController = new TextEditingController();
      _textboxes = new List.from(_textboxes)
        ..add(
          new TextFormField(
            onSaved: (String value) {
              _textboxesData.add(_textboxesController.text);
            },
            validator: (String value) {
              if (value.isEmpty)
                return "Please add a Language or delete this box!";
              if (filter.isProfane(value.replaceAll(new RegExp(r'\ '), '')))
                return "You cannot use these kind of words~!";
              return null;
            },
            style: Constants.formContentStyle(),
            controller: _textboxesController,
            decoration: Constants.dynamicFormDecoration(
                "Language Used",
                new IconButton(
                  icon: new Icon(Icons.delete),
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
      _techTextboxes = new List.from(_techTextboxes)
        ..add(
          new TextFormField(
            onSaved: (String value) {
              _techTextboxesData.add(_techTextboxesController.text);
            },
            validator: (String value) {
              if (value.isEmpty)
                return "Please add a Technology or remove this box!";
              if (filter.isProfane(value.replaceAll(new RegExp(r'\ '), '')))
                return "You cannot use these kind of words~!";
              return null;
            },
            style: Constants.formContentStyle(),
            controller: _techTextboxesController,
            decoration: Constants.dynamicFormDecoration(
                "Technology Used",
                new IconButton(
                  icon: new Icon(Icons.delete),
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
    return new Container(
      margin: Constants.form_column_margins,
      child: new TextFormField(
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        autocorrect: Constants.has_autocorrect,
        style: Constants.formContentStyle(),
        decoration: Constants.formDecoration(Texts.project_name),
        onSaved: (String name) {
          this._name = name;
        },
        validator: ProjectNameValidator.validate,
      ),
    );
  }

  Container buildEmailBox() {
    return new Container(
      margin: Constants.form_column_margins,
      width: MediaQuery.of(context).size.width *
          Constants.project_name_screen_percent,
      child: new TextFormField(
        textInputAction: TextInputAction.next,
        style: Constants.formContentStyle(),
        decoration: Constants.formDecoration("Contact Email, if any"),
        onSaved: (String email) {
          _contactPlatforms['email'] = email;
        },
        validator: (String email) {
          if (email.length >= 1) {
            if (!email.contains('@')) return "This email is not valid!";
            if (filter.isProfane(email.replaceAll(new RegExp(r'\ '), '')))
              return "You cannot use these kind of words~!";
          }
          return null;
        },
      ),
    );
  }

  Container buildGithubBox() {
    return new Container(
      margin: Constants.form_column_margins,
      width: MediaQuery.of(context).size.width *
          Constants.project_name_screen_percent,
      child: new TextFormField(
        textInputAction: TextInputAction.next,
        style: Constants.formContentStyle(),
        decoration: Constants.formDecoration("Github username, if any"),
        onSaved: (String gitUser) {
          this._contactPlatforms['githubUsername'] = gitUser;
        },
      ),
    );
  }

  Container buildDiscordUsernameBox() {
    return new Container(
      margin: Constants.form_column_margins,
      width: MediaQuery.of(context).size.width *
          Constants.project_name_screen_percent,
      child: new TextFormField(
        style: Constants.formContentStyle(),
        decoration: Constants.formDecoration("Discord username"),
        onSaved: (String discordUsername) {
          this._contactPlatforms['discordUsername'] = discordUsername;
        },
        validator: (String value) {
          if (filter.isProfane(value.replaceAll(new RegExp(r'\ '), '')))
            return "You cannot use these kind of words~!";
          if (value.length >= 1) {
            if (!value.contains('#')) {
              return "This is not a valid Discord username";
            }
            List separatedValue = value.split('#');
            if (!_isNumeric(separatedValue[1])) {
              return "These are not numeric values!";
            } else {
              if (separatedValue[1].length < 4) {
                return "There is less than 4 digits after the #.";
              }
            }
          }
          return null;
        },
      ),
    );
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return (int.parse(s) != null);
  }

  Container buildDescriptionBox() {
    return new Container(
      margin: Constants.form_column_margins,
      width: MediaQuery.of(context).size.width,
      child: new TextFormField(
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

  Row buildTeamSizeInput() {
    return new Row(
      children: <Widget>[
        new Text(
          "Number of Team Members ",
          style: new TextStyle(
            color: Constants.generalTextColor,
          ),
        ),
        new Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.06,
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(7),
          child: new TextFormField(
            keyboardType: TextInputType.number,
            style: Constants.formContentStyle(),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: Constants.formDecoration(''),
            validator: (String value) {
              if (value.isEmpty) return "You must have at least one team mate!";
              int parsed = int.parse(value);
              if (parsed < 0) return "You cannot have less than 0 team mates!";
              if (parsed == 0) return "You cannot have no team mates!";
              if (parsed > 99) return "That's way to many people!";
              return null;
            },
            onSaved: (String value) {
              this._teamMembers = value;
            },
          ),
        ),
      ],
    );
  }

  Container buildComplexityDropdow() {
    return new Container(
        margin: Constants.form_column_margins,
        padding: Constants.complexity_padding,
        decoration: Constants.complexitiesDecoration(),
        child: new Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Constants.sideBackgroundColor),
          child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                  style: new TextStyle(color: Constants.flavorTextColor),
                  hint: new Text(
                    "Complexity",
                    style: new TextStyle(color: Constants.generalTextColor),
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
    return new Container(
        margin: Constants.complexity_padding,
        child: new Center(
            child: new FlatButton(
          color: Colors.transparent,
          child: new Column(
            children: <Widget>[
              new Text('Add Project'),
              new Icon(Icons.add),
            ],
          ),
          textColor: Constants.acceptButtonColor,
          onPressed: (() async {
            switch (_connectionSources.keys.toList()[0]) {
              case ConnectivityResult.wifi:
              case ConnectivityResult.mobile:
                if (_oneToThen.isBefore(new DateTime.now()) ||
                    _oneToThen.isAtSameMomentAs(new DateTime.now())) {
                  FirebaseUser user;
                  await _auth.currentUser().then((onValue) => user = onValue);
                  DocumentReference thisUser = Firestore.instance
                      .collection('users')
                      .document(user.displayName);
                  DocumentSnapshot snapshot = await thisUser.get();
                  if (snapshot.data['createdProjects'].length <= 5) {
                    showFlash(
                        context: context,
                        duration: new Duration(seconds: 1),
                        builder: (context, controller) {
                          return new Flash(
                            controller: controller,
                            style: FlashStyle.grounded,
                            backgroundColor: Constants.sideBackgroundColor,
                            boxShadows: kElevationToShadow[4],
                            child: new FlashBar(
                              message: new Text(
                                "Creating project...",
                                style: new TextStyle(
                                  color: Constants.generalTextColor,
                                ),
                              ),
                            ),
                          );
                        });
                    this.submitProject();
                  } else {
                    showFlash(
                        context: context,
                        duration: new Duration(seconds: 1),
                        builder: (context, controller) {
                          return new Flash(
                            controller: controller,
                            style: FlashStyle.grounded,
                            backgroundColor: Constants.sideBackgroundColor,
                            boxShadows: kElevationToShadow[4],
                            child: new FlashBar(
                              message: new Text(
                                "You've created too many projects!",
                                style: new TextStyle(
                                  color: Constants.generalTextColor,
                                ),
                              ),
                            ),
                          );
                        });
                  }
                } else {
                  Duration timeToThen =
                      _oneToThen.difference(new DateTime.now());
                  showFlash(
                      context: context,
                      duration: new Duration(seconds: 1),
                      builder: (context, controller) {
                        return new Flash(
                          controller: controller,
                          style: FlashStyle.grounded,
                          backgroundColor: Constants.sideBackgroundColor,
                          boxShadows: kElevationToShadow[4],
                          child: new FlashBar(
                            message: new Text(
                              "You must wait ${timeToThen.inSeconds} seconds",
                              style: new TextStyle(
                                color: Constants.generalTextColor,
                              ),
                            ),
                          ),
                        );
                      });
                }
                break;
              case ConnectivityResult.none:
                showFlash(
                    context: context,
                    duration: new Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.grounded,
                        backgroundColor: Constants.sideBackgroundColor,
                        boxShadows: kElevationToShadow[4],
                        child: new FlashBar(
                          message: new Text(
                            "No Internet Connection Detected",
                            style: new TextStyle(
                              color: Constants.generalTextColor,
                            ),
                          ),
                        ),
                      );
                    });
                break;
            }
          }),
        )));
  }

  dynamic submitProject() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this._oneToThen = _time.add(new Duration(minutes: 1));
      this._time = new DateTime.now();
      FirebaseUser _user = await _auth.currentUser();
      CollectionReference projects = db.collection('projects');
      CollectionReference users = db.collection('users');
      DocumentReference userDocument = users.document(_user.displayName);
      Project project = new Project(
          _complexity,
          _contactPlatforms,
          _description,
          _name,
          [],
          _user.displayName,
          _textboxesData,
          _techTextboxesData,
          _teamMembers);
      DocumentReference createdProject = await projects.add(project.toMap());
      userDocument.updateData({
        'createdProjects': FieldValue.arrayUnion([createdProject]),
      });
      showFlash(
          context: context,
          duration: new Duration(seconds: 1),
          builder: (context, controller) {
            return new Flash(
              controller: controller,
              style: FlashStyle.grounded,
              backgroundColor: Constants.sideBackgroundColor,
              boxShadows: kElevationToShadow[4],
              child: new FlashBar(
                message: new Text(
                  "Project created!",
                  style: new TextStyle(
                    color: Constants.generalTextColor,
                  ),
                ),
              ),
            );
          });
      this.clearBoxes();
    }
  }

  void clearBoxes() {
    this._contactPlatforms = new Map<String, dynamic>();
    this.complexities = new List<String>();
    this._textboxes = new List<Widget>();
    this._textboxesData = new List<String>();
    this._techTextboxes = new List<Widget>();
    this._techTextboxesData = new List<String>();
  }
}
