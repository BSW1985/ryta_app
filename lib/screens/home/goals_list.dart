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

    //final user = Provider.of<RytaUser>(context);
    final goals = Provider.of<List<Goal>>(context);
    // final goals = Provider.of<QuerySnapshot>(context);

    // if (goals == null) {
      // call DatabaseService.ListOfGoals();
      //    print(DatabaseService.finalGoalsList.toString());
    //     return CircularProgressIndicator();
    //   } else {
    //     // for (var doc in goals.docs) {
    //     //   print(doc.data);
    //     // }
    //     return Container();
    //   }
      // dynamic goals = DatabaseService().getGoals();
      


        // return Scaffold(
        //   backgroundColor: Colors.white,
        //   body: Form(
        //   child: Center(
        //             child: ElevatedButton(
        //             child: Text(
        //               'PRINT',
        //               //style: TextStyle(color: Colors.white),
        //               ),
        //             onPressed: () async {
        //               // getData(user.uid);
        //               print(goals.length);

        //               for (var doc in goals) {
        //                 print(doc.goal);
        //                 print(doc.imageUrl);
        //               }



        //               }
        //     ),
        //   ),
        //   ),
                  
        //           );


    


    // for (var doc in goals.docs) {
    //   print(doc.data);
    // }

    
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalTile(goal: goals[index]);
      }); 
      
    // );
  }

      
    // void getData(uid) {
    // FirebaseFirestore.instance
    //     .collection("ryta_users")
    //     .doc(uid)
    //     .collection('goals')
    //     .get()
    //     .then((QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((user) {
    //     print(user['goal']); 
    //     print(user['imageUrl']);
    //     }
    //     );
    //     });
    // }
}