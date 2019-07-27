// Dependencies for the database, async and await properties and also the path parsing
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'dart:async';
import 'package:teambuilder/util/constants.dart';

// Models in the database
import 'package:teambuilder/models/project.dart';
import 'package:teambuilder/models/user.dart';

class DBManager {
  static Database dbInstance;

  //Property
  Future<Database> get db async {
    if (dbInstance == null) dbInstance = await initDB();
    return dbInstance;
  }

  //Initializes the database link from dart to the database file
  initDB() async {
    String databasesDirectory = await getDatabasesPath();
    String path = join(databasesDirectory, Constants.database_filename);
    var db = await openDatabase(path,
        onCreate: onCreateFunction, version: Constants.database_version);
    return db;
  }

  //What to do when the link is created and the database is completely new
  void onCreateFunction(Database db, int version) async {
    await db.execute(Constants.on_create_SQL);
  }

  Future <List<User>> getAllUsers() async{
    var dbLink = await db;
    List <Map> allUsers = await dbLink.rawQuery("""SELECT * FROM users""");
    List <User> users = new List();

    for (int index = 0; index < allUsers.length; index++){
      User user = new User();
      user.id = allUsers[index]['id'];
      user.email = allUsers[index]['email'];
      user.username = allUsers[index]['username'];
      user.password = allUsers[index]['password'];
      users.add(user);
    }
    return users;
  }

  //Now to tell the queries of the database, and the mutations we can perform
  Future<List<Project>> getAllProjects() async {
    var dbLink = await db;
    List<Map> allItems = await dbLink.rawQuery(Constants.select_all_from_db);
    List<Project> projects = new List();

    for (int index = 0; index < allItems.length; index++) {
      Project pj = new Project();
      pj.contactPlatforms = allItems[index]['contactPlatforms'];
      pj.complexity = allItems[index]['complexity'];
      pj.description = allItems[index]['description'];
      pj.name = allItems[index]['name'];
      pj.id = allItems[index]['id'];
      projects.add(pj);
    }
    return projects;
  }
  authenticate(String username, String field) async {
    var dbLink = await db;
    await dbLink.query('users',where:"""$field=$username;""" );
  }
  getUser(User user) async{
    var dbLink = await db;
    List<Map> usr = await dbLink.rawQuery("""SELECT * FROM ${Constants.users_query_name} WHERE username=${user.username};""");
    User use = new User();
    use.email = usr[0]['email'];
    use.id = usr[0]['id'];
    use.password = usr[0]['password'];
    use.username = usr[0]['username'];
    return use;
  }

  //Inserts a user to the database
  insertUser(User user)async{
    var dbLink = await db;
    dbLink.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  //Inserts a project into the database
  insertProject(Project pj) async {
    var dbLink = await db;
    dbLink.insert(Constants.projects_query_name, pj.toMap());
  }

  //Updates to a given value an existing project. When the app scales, this should only be available to the project owner
  updateProject(Project pj) async {
    var dbLink = await db;
    dbLink.update(Constants.projects_query_name, pj.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, where: """id=${pj.id}""");
  }

  //Deletes a given project from the database. Again, only available to the project's owner
  deleteProject(Project pj) async {
    var dbLink = await db;
    dbLink.delete(Constants.projects_query_name, where: """id=${pj.id}""");
  }

  deleteProjects() async {
    var dbLink = await db;
    dbLink.delete(Constants.projects_query_name);
  }
  /*A glimpse to the future can be
  Future <List<Project>> userProjects(User user) async{
    And inside there can be something similar to
    SELECT * FROM projects WHERE userId=${user.id}
    and the userId parameter will be autogenerated by Google Auth service,
    Google Accounts
  }
  */
}
