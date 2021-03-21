import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/goal_tile.dart';
import 'package:ryta_app/services/database.dart';

class GoalsList extends StatefulWidget {
  @override
  _GoalsListState createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<Goal>>(context);

    return ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          return GoalTile(goal: goals[index]);
        });

  }
  }