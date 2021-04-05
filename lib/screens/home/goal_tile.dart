import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/goal_view.dart';
import 'package:ryta_app/services/database.dart';

// currently unused GoalTile
class GoalTile extends StatelessWidget {

  final Goal goal;
  GoalTile({this.goal});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<RytaUser>(context);     

    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  // open [ImagePage] with the given image
                  GoalPage(goal, goal.imageID, goal.imageUrl),
              ),
              );
            },
          onLongPress: () {
           _onBackPressed(context, user);
          },
          child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(goal.goalname),
            subtitle: Text(goal.goalmotivation),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(context, RytaUser user) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Delete this goal?'),
      // content: new Text('Do you want to delete the goal?'),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            DatabaseService(uid: user.uid).deleteUserGoals(goal.goalID);
          },
          // Navigator.of(context).pop(),
          child: Text("Yes"),
        ),
      ],
    ),
  );
  }
}