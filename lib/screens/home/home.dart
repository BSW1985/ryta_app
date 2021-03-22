import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/screens/home/goals_list.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<RytaUser>(context);

    /* EDIT: Set up the home screen */
    return StreamProvider<List<Goal>>.value(
        value: DatabaseService(uid: user.uid).goals,
        initialData: null,
        child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Your Goals',
            style: TextStyle(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
              // Enable to log out from the Home screen. Placed in upper right corner.
              TextButton.icon( 
                icon: Icon(Icons.person), 
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
          body: GoalsList(),
        
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              DatabaseService(uid: user.uid).addUserGoals('new goal 4', 'IMAGE_URL'); 
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF995C75),
          ),
          ),
      );
  }
}