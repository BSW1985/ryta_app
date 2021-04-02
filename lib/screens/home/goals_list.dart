import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/config/keys.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/goal_definition.dart';
import 'package:ryta_app/screens/home/goal_image_search.dart';
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
    final user = Provider.of<RytaUser>(context);

                  if (Keys.UNSPLASH_API_CLIENT_ID == "ask_Marek")
                    return AlertDialog(
                      title: Text('Ask Marek for Unsplash keys'),
                      content: Text('Othewise it will not work'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Mach ich!'),
                          onPressed: (){
                            // Hier passiert etwas
                            // Navigator.of(context).pop();
                          }
                        ),
                      ],
                    );
    
    return Scaffold(
        body: 

        
        
        ListView.builder(
        itemCount: goals == null ? 0 : goals.length,
        itemBuilder: (context, index) {
          return GoalTile(goal: goals[index]);
        }),
        
        // add goal to Firebase
        floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GoalDefinition()));
                DatabaseService(uid: user.uid).addUserGoals('new goal 4', 'IMAGE_URL'); 
              },
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF995C75),
            ),
        floatingActionButtonLocation:    
          FloatingActionButtonLocation.centerFloat,

    ); 
  }
}