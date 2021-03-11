import 'package:flutter/material.dart';
import 'package:ryta_app/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('All Your Goals'),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
            TextButton.icon( 
              icon: Icon(Icons.person), 
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: ListView(
        padding: EdgeInsets.symmetric(vertical: 230.0, horizontal: 30.0),
        children: [
            Text('All Your Goals',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
            ),
        ],
      ),
    );
  }
}