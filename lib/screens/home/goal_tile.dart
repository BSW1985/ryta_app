import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/database.dart';

class GoalTile extends StatelessWidget {

  final Goal goal;
  GoalTile({this.goal});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<RytaUser>(context);

    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: GestureDetector(
          onLongPress: () async {
            DatabaseService(uid: user.uid).deleteUserGoals(goal.goalID);
          },
          child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(goal.goal),
            subtitle: Text(goal.imageUrl),
          ),
        ),
      ),
    );
  }
}