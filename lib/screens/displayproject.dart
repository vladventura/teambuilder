part of project;

/// This module is built to construct a page for the clickable object generated by the [DisplayProjects] module.
///
/// There seems to be quite a lot happening here, but there's really not. It's mostly Firestore patterns to follow.
class _DisplayProject extends StatefulWidget {
  _DisplayProject({@required this.document, @required this.user});
  final DocumentSnapshot document;
  final FirebaseUser user;
  _DisplayProjectState createState() => new _DisplayProjectState();
}

class _DisplayProjectState extends State<_DisplayProject> {
  final Firestore _db = Firestore.instance;
  int _groupValue = 1;
  String _specialization = "Frontend";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Project Details"),
        backgroundColor: Constants.sideBackgroundColor,
        iconTheme: new IconThemeData(
          color: Constants.flavorTextColor,
        ),
        textTheme: new TextTheme(
          title: new TextStyle(
            color: Constants.generalTextColor,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Constants.mainBackgroundColor,
      body: new ListView(
        physics: new BouncingScrollPhysics(),
        padding: new EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        children: <Widget>[
          new Text(
            "${widget.document.data['name']} by ${widget.document.data['originator']}",
            style: new TextStyle(
              fontSize: 30,
              color: Constants.flavorTextColor,
            ),
          ),
          this.buildSizedBoxHeight(0.05),
          this.buildHeaderText("Description"),
          this.buildDivider(),
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 5),
            child: new Text(widget.document.data['description'],
                style: new TextStyle(
                    fontSize: 18, color: Constants.flavorTextColor)),
          ),
          this.buildSizedBoxHeight(0.1),
          this.buildHeaderText("Members"),
          this.buildDivider(),
          this.buildMembersList(),
          this.buildSizedBoxHeight(0.1),
          this.buildHeaderText("Languages Used"),
          this.buildDivider(),
          this.buildElements(widget.document.data['languagesUsed']),
          this.buildSizedBoxHeight(0.1),
          this.buildHeaderText("SDKs and Frameworks Used"),
          this.buildDivider(),
          this.buildElements(widget.document.data['technologiesUsed']),
          this.buildSizedBoxHeight(0.1),
          this.buildHeaderText("Contact Platforms"),
          this.buildDivider(),
          this.buildContactPlatformButtons(),
          this.buildSizedBoxHeight(0.1),
          this.buildButtons(),
        ],
      ),
    );
  }

  Text buildHeaderText(String headerText) {
    return new Text(
      headerText,
      style: new TextStyle(
        fontSize: 25,
        color: Constants.generalTextColor,
      ),
    );
  }

  Divider buildDivider() {
    return new Divider(
      thickness: 1.5,
      color: Constants.acceptButtonColor,
    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return new SizedBox(
      height: MediaQuery.of(context).size.height * height,
    );
  }

  Column buildContactPlatformButtons() {
    List<Widget> contactPlatformButtons = new List();
    List<String> emailAndDomain = new List();
    List<String> discordAndHash = new List();

    if (widget.document.data['contactPlatforms'] != null) {
      if (!widget.document.data['contactPlatforms']['email'].isEmpty) {
        emailAndDomain =
            widget.document.data['contactPlatforms']['email'].split('@');
        if (emailAndDomain[1].contains('outlook') ||
            emailAndDomain[1].contains('live') ||
            emailAndDomain[1].contains('hotmail')) {
          contactPlatformButtons.add(
            new Container(
              padding: new EdgeInsets.all(5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5),
                color: new Color(0xFF0072C6), //#0072C6
              ),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    MdiIcons.outlook,
                    color: Colors.white,
                  ),
                  new Text(emailAndDomain[0] + "@" + emailAndDomain[1],
                      style: new TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        } else if (emailAndDomain[1].contains('gmail')) {
          contactPlatformButtons.add(
            new Container(
              padding: new EdgeInsets.all(5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5),
                color: new Color(0XFFD44638), //#D44638
              ),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    MdiIcons.gmail,
                    color: Colors.white,
                  ),
                  new Text(
                    emailAndDomain[0] + "@" + emailAndDomain[1],
                    style: new TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else {
          contactPlatformButtons.add(new Container(
            padding: new EdgeInsets.all(5),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              color: Colors.black,
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  MdiIcons.email,
                  color: Colors.white,
                ),
                new Text(
                  emailAndDomain[0] + "@" + emailAndDomain[1],
                  style: new TextStyle(color: Colors.white),
                ),
              ],
            ),
          ));
        }
      }

      if (!widget
          .document.data['contactPlatforms']['discordUsername'].isEmpty) {
        discordAndHash = widget
            .document.data['contactPlatforms']['discordUsername']
            .split('#');
        contactPlatformButtons.add(new Container(
            padding: new EdgeInsets.all(5),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              color: new Color(0xFF738ADB), //#738ADB
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  MdiIcons.discord,
                  color: Colors.white,
                ),
                new Text(
                  discordAndHash[0] + "#" + discordAndHash[1],
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )));
      }

      if (!widget.document.data['contactPlatforms']['githubUsername'].isEmpty) {
        contactPlatformButtons.add(new Container(
            padding: new EdgeInsets.all(5),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              color: Colors.black,
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  MdiIcons.githubBox,
                  color: Colors.white,
                ),
                new Text(
                  widget.document.data['contactPlatforms']['githubUsername'],
                  style: new TextStyle(color: Colors.white),
                ),
              ],
            )));
      }
    }

    if (contactPlatformButtons.isEmpty) {
      contactPlatformButtons.add(new Container(
          padding: new EdgeInsets.all(5),
          decoration: new BoxDecoration(
              color: Colors.black, borderRadius: new BorderRadius.circular(5)),
          child: new Text(
            "The owner didn't specify no platform~!",
            style: new TextStyle(color: Colors.white),
          )));
    }
    return new Column(
      children: contactPlatformButtons,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget buildMembersList() {
    bool isEmpty = (widget.document.data['joinedUsers'].length <= 0 ||
        widget.document.data['joinedUsers'] == null);
    if (!isEmpty)
      return new Container(
        margin: new EdgeInsets.symmetric(horizontal: 5),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.document.data['joinedUsers']
                .map((user) => new Text(
                      "${user['name']} (${user['specialization']})",
                      style: new TextStyle(
                          fontSize: 18, color: Constants.flavorTextColor),
                    ))
                .toList()),
      );
    return new Container(
      child: new Text("Nothing to show here~!"),
    );
  }

  Widget buildElements(List<dynamic> elements) {
    bool isEmpty = (elements.length <= 0 || elements == null);
    if (!isEmpty)
      return new Container(
        margin: new EdgeInsets.symmetric(horizontal: 5),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: elements
                .map((element) => new Text(
                      element,
                      style: new TextStyle(
                          fontSize: 18, color: Constants.flavorTextColor),
                    ))
                .toList()),
      );
    return new Container(
      child: new Text("Nothing to show here~!"),
    );
  }

  dynamic buildButtons() {
    bool owner =
        (widget.document.data['originator'] == widget.user.displayName);
    bool isJoined = (widget.document.data['joinedUsers']
            .where((element) => element['name'] == widget.user.displayName)
            .length >
        0);
    bool belongs = (isJoined || owner);
    bool slotAvailable = (widget.document.data['joinedUsers'].length <
        int.parse(widget.document.data['teamMembers']));
    if (!belongs) {
      if (slotAvailable == true) {
        return this.buildJoinButton();
      } else {
        return new FlatButton(
          child: new Text(
            "The team is full.",
            style: new TextStyle(
              fontSize: 18,
            ),
          ),
          onPressed: null,
        );
      }
    } else if (owner) {
      return new FlatButton(
        child: new Text(
          "Delete",
          style:
              new TextStyle(fontSize: 18, color: Constants.cancelButtonColor),
        ),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  backgroundColor: Constants.mainBackgroundColor,
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("No"),
                      textColor: Constants.acceptButtonColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    new FlatButton(
                      child: new Text("Yes"),
                      textColor: Constants.cancelButtonColor,
                      onPressed: () async => this.deleteProject(),
                    ),
                  ],
                  title: new Text("Delete Project",
                      style: TextStyle(color: Constants.generalTextColor)),
                  content: new Text(
                    "Are you sure you want to delete this project? All data related to it will be lost",
                    style: TextStyle(
                      color: Constants.generalTextColor,
                    ),
                  ),
                );
              });
        },
      );
    } else if (belongs) {
      return this.buildLeaveButton();
    }
  }

  void deleteProject() async {
    DocumentReference thisProject =
        _db.collection('projects').document(widget.document.documentID);
    DocumentReference thisUserDocument =
        _db.collection('users').document(widget.user.displayName);

    await thisUserDocument.updateData({
      'joinedProjects': FieldValue.arrayRemove([thisProject])
    });

    thisProject.delete().then((nothing) {
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
                "Project Deleted",
                style: new TextStyle(
                  color: Constants.generalTextColor,
                ),
              )),
            );
          });
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
    });
  }

  FlatButton buildJoinButton() {
    return new FlatButton(
      color: Constants.acceptButtonColor,
      child: new Text("Join Project", style: new TextStyle(fontSize: 15)),
      onPressed: () {
        this._showSpecializationChooser();
      },
    );
  }

  FlatButton buildLeaveButton() {
    return new FlatButton(
      color: Constants.cancelButtonColor,
      child: new Text(
        'Leave Project',
        style: new TextStyle(
          fontSize: 15,
        ),
      ),
      onPressed: () async {
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
                    "Leaving team...",
                    style: new TextStyle(
                      color: Constants.generalTextColor,
                    ),
                  ),
                ),
              );
            });

        CollectionReference projects = _db.collection('projects');
        CollectionReference users = _db.collection('users');
        DocumentReference thisProject = projects.document(document.documentID);
        DocumentReference userDocument = users.document(_user.displayName);
        DocumentSnapshot currentJoinedUsers = await thisProject.get();
        dynamic without = currentJoinedUsers.data['joinedUsers']
            .where((element) => element['name'] != _user.displayName);

        thisProject.updateData({
          'joinedUsers': without.toList(),
          'joinedUserNames': FieldValue.arrayRemove([_user.displayName])
        });
        userDocument.updateData({
          'joinedProjects': FieldValue.arrayRemove([
            thisProject,
          ])
        }).then((onValue) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Home', (Route<dynamic> route) => false);
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
                      "Left team successfully.",
                      style: new TextStyle(
                        color: Constants.generalTextColor,
                      ),
                    ),
                  ),
                );
              });
        });
      },
    );
  }

  Future<Null> _showSpecializationChooser(DocumentSnapshot document) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Most comfortable area?"),
            backgroundColor: Constants.sideBackgroundColor,
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new RadioListTile(
                  activeColor: Constants.flavorTextColor,
                  groupValue: _groupValue,
                  onChanged: (int val) {
                    this.handleRadioChange(document, val);
                  },
                  value: 1,
                  title: new Text("Frontend"),
                ),
                new RadioListTile(
                  activeColor: Constants.flavorTextColor,
                  groupValue: _groupValue,
                  onChanged: (int val) {
                    this.handleRadioChange(document, val);
                  },
                  value: 2,
                  title: Text("Backend"),
                ),
                this.buildJoinConfirm(document),
              ],
            ),
          );
        });
  }

  void handleRadioChange(DocumentSnapshot document, int val) {
    setState(() {
      _groupValue = val;
      if (val == 1) {
        _specialization = "Frontend";
      } else if (val == 2) {
        _specialization = "Backend";
      }
    });
    // KLUDGE: Popping the alert box and calling it again because it is rendered outside the build tree
    Navigator.of(context).pop();
    this._showSpecializationChooser(document);
  }

  RaisedButton buildJoinConfirm(DocumentSnapshot document) {
    return new RaisedButton(
      child: new Text("Join Project"),
      color: Constants.acceptButtonColor,
      onPressed: () async {
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
                    "Joining team...",
                    style: new TextStyle(
                      color: Constants.generalTextColor,
                    ),
                  ),
                ),
              );
            });
        FirebaseUser _user;
        await FirebaseAuth.instance.currentUser().then((ref) => _user = ref);
        CollectionReference projects = _db.collection('projects');
        CollectionReference users = _db.collection('users');
        DocumentReference thisProject = projects.document(document.documentID);
        DocumentReference userDocument = users.document(_user.displayName);
        thisProject.updateData({
          'joinedUsers': FieldValue.arrayUnion([
            {'name': _user.displayName, 'specialization': _specialization}
          ]),
          'joinedUserNames': FieldValue.arrayUnion([_user.displayName])
        });
        userDocument.updateData({
          'joinedProjects': FieldValue.arrayUnion([
            thisProject,
          ])
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
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
                    "Team joined!",
                    style: new TextStyle(
                      color: Constants.generalTextColor,
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
