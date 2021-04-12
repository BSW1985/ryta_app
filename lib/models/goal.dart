import 'package:flutter/material.dart';
// Model for a goal during its definition

class Goal {

  final String goalID;
  String goalname;
  String goalmotivation;
  String imageUrl;
  String imageID;
  String goalBackgoundColor;
  String goalFontColor;
  String goalCategory;

  Goal({ this.goalID, this.goalname, this.goalmotivation, this.imageUrl, this.imageID, this.goalBackgoundColor, this.goalFontColor, this.goalCategory });
}