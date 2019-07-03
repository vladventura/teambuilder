import 'package:flutter/material.dart';
// To keep a structured and organized, concise code
// I'll import the texts from the Texts file
import 'texts.dart';

class Constants {
  // Tabs information
  static const app_tabs = 2;
  static const join_project = {
    'text': Texts.join_project,
    'icon': Icon(Icons.search) 
  };
  static const create_project = {
    'text': Texts.create_project,
    'icon': Icon(Icons.search)
  };

  // Form information
  static const decoration_width = 2.0;
  static const form_column_margins = EdgeInsets.all(5);
  static const project_name_screen_percent = .60;
  static const description_max_lines = 5;
  static const description_max_length = 500;
  static const has_autocorrect = true;
  static const max_length_enforced = true;
  static const complexity_padding = EdgeInsets.symmetric(horizontal: 5);
    // Decorations
  static formDecoration(String formName){
    return InputDecoration(
      labelText: formName,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(
          color: main_color,
          width: decoration_width,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: side_color,
          width: decoration_width,
        ),
      ),
    );
  }
  static complexitiesDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      border: Border.all(
        color: side_color,
        width: decoration_width,
        ),
    );
  }

  // Team button information
  static buttonDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: side_color,
        width: decoration_width,
        style: BorderStyle.solid,
      )
    );
  }
 
  // Database information
  static const database_filename = 'projects.db';
  static const database_query_name = 'projects';
  static const database_version = 1;
  static const on_create_SQL = 
    """
    CREATE TABLE $database_query_name(id INTEGER PRIMARY KEY AUTOINCREASE,
    name TEXT, description TEXT, complexity TEXT, contactPlatforms TEXT);
    """;
  static const select_all_from_db = """SELECT * FROM projects""";

  // General information
  static const items_per_row = 5;
  static const item_size = 5.0;
  static const main_color = Color (0xFF9BBC0F);
  static const side_color = Color (0xFF8BAC0F);
  static const third_color = Color (0xFF306230);
  static const spacing = 3.0;
  static const appbar_elevation = 2.0;
}