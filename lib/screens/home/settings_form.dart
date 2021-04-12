import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  SizedBox(height: 70.0),
                  Text(
                  "Unleash Ryta's full potential:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                  SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left:50.0, right: 50.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.check_circle_outline, color: Colors.green[700]),
                          minVerticalPadding: 0.0,
                          contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                          title: new Text('Smart Notifications', style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: new Text('Get notified about your goal everytime you need it the most'),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle_outline, color: Colors.green[700]),
                          minVerticalPadding: 0.0,
                          contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                          title: new Text('Upload your own images', style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: new Text('Personalize Ryta even more to suit you best'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF9A825)),
                    ),
                    child: Text(
                      'UPGRADE TO PREMIUM',
                      ),
                    onPressed: () async {
  
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                      title: Row(
                          children:[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.thumb_up_alt, color: Color(0xFFF9A825), size: 40.0,),
                            ),
                            Flexible(child: Text('We are doing our best to make these features available!')),
                            ]
                          ),
                      content:
                        RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "We appreciate your interest! If you like our vision, have other ideas or would like to give us personal feedback, please contact us at ",
                                  style: TextStyle(color: Colors.black),
                                ),
                                
                                // ignore: todo
                                // TODO: make the link work!!!
                                TextSpan(
                                  text: "info@ryta.eu",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    recognizer: TapGestureRecognizer()..onTap =  () async{
                                      var url = 'https://www.ryta.eu/';
                                          if (await canLaunch(url)) {
                                            await launch(url.toString());
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                    }
                                ),
                                TextSpan(
                                  text: ". Your Ryta team :)",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ]
                          ),
                        ),
                      // actions: <Widget>[
                      //   TextButton(
                      //     child: Text('Back to the app'),
                      //     onPressed: (){
                      //       Navigator.of(context).pop();
                      //     }
                      //   ),
                      // ],
                    ),
                    );


                    // Set willToPay to True
                    DatabaseService(uid: user.uid).updateUserWillingnessToPay(true);

                    

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