import 'package:flutter/material.dart';

class Constants {


  // Tabs information
  static const app_tabs = 2;
  static const join_project = {
    'text': 'Join Project',
    'icon': Icon(Icons.search) 
  };
  static const create_project = {
    'text': 'Create Project',
    'icon': Icon(Icons.search)
  };

  // Form information
  static const form_column_margins = EdgeInsets.all(5);
  static const project_name_screen_percent = .60;
  static const description_max_lines = 5;
  static const description_max_length = 500;
  static const has_autocorrect = true;
  static const max_length_enforced = true;

  static formDecoration(String formName){
    const borderDecoWidth = 2.0;
    return InputDecoration(
      labelText: formName,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(
          color: main_color,
          width: borderDecoWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: side_color,
          width: borderDecoWidth,
        ),
      ),
    );
  }



  static const items_per_row = 5;
  static const item_size = 5.0;
  static const main_color = Color (0xFF9BBC0F);
  static const side_color = Color (0xFF8BAC0F);
  static const third_color = Color (0xFF306230);
  static const spacing = 3.0;

  static const homescreen_appbar_title = Text ('Main Menu');
  static const appbar_elevation = 2.0;
}