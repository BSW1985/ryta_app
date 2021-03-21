import 'package:flutter/material.dart';
import 'package:ryta_app/models/goal.dart';

class GoalTile extends StatelessWidget {

  final Goal goal;
  GoalTile({this.goal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(goal.goal),
          subtitle: Text(goal.imageUrl),
        ),
      ),
    );
  }
}