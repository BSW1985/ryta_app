import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/screens/home/goals_list.dart';

class Home extends StatefulWidget{
  @override
  _Home createState()=> _Home();
}

class _Home extends State<Home> {

  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Container(),
    Container(),
    GoalsList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSettingsPanel() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Text('bottom sheet'),
      );
    });
  }

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
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: SizedBox(
              height: 70,
              child: Image.asset("assets/ryta_logo.png"),
          actions: <Widget>[
              // Enable to log out from the Home screen. Placed in upper right corner.
              TextButton.icon( 
                icon: Icon(Icons.person), 
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),

//             ],
//           ),
//           body: GoalsList(),
        
//           floatingActionButton: FloatingActionButton(
//             onPressed: () async {
//               DatabaseService(uid: user.uid).addUserGoals('new goal 4', 'IMAGE_URL'); 
//             },
//             child: Icon(Icons.add),
//             backgroundColor: Color(0xFF995C75),
//           ),
//           ),
//       );

             /* TextButton.icon(
                icon: Icon(Icons.settings),
                label: Text('settings'),
                onPressed: () => _showSettingsPanel(),
              ) */
            ],
          ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        // Implementing the toolbar
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
    )
    );
  }
}