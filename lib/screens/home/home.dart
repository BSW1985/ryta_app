import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          // ListView(
          // padding: EdgeInsets.symmetric(vertical: 230.0, horizontal: 30.0),
          // children: [
          //     Text('All Your Goals',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(fontSize: 30),
          //     ),
          //   ],
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              DatabaseService(uid: user.uid).updateUserGoals('new goal 4', 'IMAGE_URL'); 
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF995C75),
          ),
          ),
      );
  }
}

      // return StreamBuilder<QuerySnapshot>(
      //   // <2> Pass `Stream<QuerySnapshot>` to stream
      //   stream: DatabaseService(uid: user.uid).goals,
      //   // ignore: missing_return
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       // <3> Retrieve `List<DocumentSnapshot>` from snapshot
      //       final List<DocumentSnapshot> documents = snapshot.data.docs;
      //       return ListView(
      //           children: documents
      //               .map((doc) => Card(
      //                     child: ListTile(
      //                       title: Text(doc['goal']),
      //                       subtitle: Text(doc['imageUrl']),
      //                     ),
      //                   ))
      //               .toList