import 'package:flutter/material.dart';

class Texts{
  // App texts
  static const homescreen_appbar_title = Text('Main Menu');
  static const app_title = 'Teambuilder';
  static const release = '-ALPHA-';
  static const appbar_title = Text('Teambuilder');
  static const appbar_join_title = Text(join_project);
  static const appbar_create_title = Text(create_project);
  static const flavor_text = "Find your next team project.";

  // Tab texts
  static const join_project = 'Join Project';
  static const create_project = "Create Project";

  // Form texts
  static const project_name = 'Project Name';
  static const project_name_error_msg = 'Please fill in a Project Name';
  static const project_description = 'Project Description';
  static const project_description_error_msg = 'Please fill in a description';
  static const complexities = [
    'Beginner', 
    'Intermediate', 
    'Expert'
  ];
  static const project_complexity_text = Text('Complexity');
}