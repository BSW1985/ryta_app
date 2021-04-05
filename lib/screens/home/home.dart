
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/goal_definition.dart';
import 'package:ryta_app/screens/home/settings_form.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/screens/home/goals_list.dart';
class Home extends StatefulWidget{
  @override
  _Home createState()=> _Home();
}

class _Home extends State<Home> {

  // final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    GoalsList(),
    SettingsForm(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void _showSettingsPanel() {
  //   showModalBottomSheet(context: context, builder: (context) {
  //     return Container(
  //       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
  //       child: Text('bottom sheet'),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<RytaUser>(context);

    // Homescreen
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
              child: Image.asset("assets/ryta_logo.png"),),

          //    /* TextButton.icon(
          //       icon: Icon(Icons.settings),
          //       label: Text('settings'),
          //       onPressed: () => _showSettingsPanel(),
          //     ) */
          
          ),
        body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
              ),

        
        // Implementing the toolbar
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: '',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.home_filled),
              //   label: ''
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            elevation: 0.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey[400],
            selectedItemColor: Color(0xFF995C75),
            onTap: _onItemTapped,
            ),


          // Start a definition of a new goal 
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              clipBehavior: Clip.none,
              onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoalDefinition())
          );
          },
          tooltip: 'Add a new goal',
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF995C75),
              ),
        ),
    );
  }
}