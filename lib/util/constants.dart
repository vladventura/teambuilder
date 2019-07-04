import 'package:flutter/material.dart';

class Constants {
  // App information related stuff
  static const app_title = 'Teambuilder';
  static const release = '-ALPHA-';
  static const appbar_title = Text('Teambuilder');

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

  static projectFormDecoration(String formName){
    const borderDecoWidth = 2.0;
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(
          color: main_color,
          width: borderDecoWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder()
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