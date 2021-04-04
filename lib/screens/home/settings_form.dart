import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/auth.dart';

///Showing a personal settings and info
class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

    final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<RytaUser>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      body: 

      Center(
              child: Form(
              child: Column(
                children: <Widget>[
                  // Implementation of the log in button.
                  SizedBox(height: 20.0),
                  Text('Your Email:'),
                  Text(user.email.toString()),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text(
                      'LOGOUT',
                      ),
                    onPressed: () async {
  
                    await _auth.signOut();

                        }
                    ),
                ],
              ),
            ),
      ),
    );
  }
}

//// Alternative Settings
/*
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> topic = ['sports', 'education', 'personality', 'nutrition', 'finance'];

  String _currentName;
  String _currentTopic;
  String _currentUrl;

  @override
  Widget build(BuildContext context) {

    RytaUser user = Provider.of<RytaUser>(context);

    return StreamBuilder<RytaUser> (
      stream: DatabaseService(uid: user.uid).RytaUser,
      builder: (context, snapshot){
        if(snapshot.hasData) {
          RytaUser userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                'Update your goals',
                style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField(
                decoration: textInputDecoration,
                items: topic.map((topic) {
                  return DropdownMenuItem(
                    value: topic,
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentTopic = val ),
              ),
                SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration,
                validator: (val) => val.isEmpty ? 'Please enter an url' : null,
                onChanged: (val) => setState(() => _currentUrl = val),
                ),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await DatabaseService(uid: user.uid).updateUserData(
                        _currentName ?? snapshot.data.name,
                        _currentName ?? snapshot.data.name,
                        _currentUrl ?? snapshot.data.strength,
                    );
                    Navigator.pop(context);
                  }
                }
              ],
            ),
          );
        }else{
            return Loading();
    }
      }
    );
  }
}
*/