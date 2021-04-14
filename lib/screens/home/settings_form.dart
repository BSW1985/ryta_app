import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
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

    int price = 0;

    bool _checkboxListTile1 = false;
    bool _checkboxListTile2 = false;
    bool _checkboxListTile3 = false;
    bool _checkboxListTile4 = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<RytaUser>(context);
    final userfile = Provider.of<UserFile>(context);

    if (userfile==null)
      return 
        Container();
      else

    if(userfile.willToPay==true) {
    _checkboxListTile1 = userfile.package1;
    _checkboxListTile2 = userfile.package2;
    _checkboxListTile3 = userfile.package3;
    _checkboxListTile4 = userfile.package4;
    price=userfile.price;}


    return NotificationListener<OverscrollIndicatorNotification>( // disabling a scroll glow
            // ignore: missing_return
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
      child: Scaffold(
      backgroundColor: Colors.white,
      body: 

      ListView(
          children: <Widget>[
            // SizedBox(height: 20.0),
            // username
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right:30.0, bottom:5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.displayName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                        SizedBox(width: 40.0),
                      // settings
                      IconButton(
                          
                          icon: Icon(
                            Icons.settings,
                            color: Color(0xFF995C75),
                          ),
                          tooltip: 'Settings',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

            // SizedBox(height: 20.0),
            // email
            Text(user.email,
            textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0),),
            SizedBox(height: 30.0),
            ElevatedButton(
              style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
              // backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              // foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF995C75)),
              // shape: MaterialStateProperty.all(RoundedRectangleBorder(
              //         // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
              //         borderRadius: BorderRadius.circular(15.0))),
              ),
              child: Text(
                'LOGOUT',
                ),
              onPressed: () async {
  
              await _auth.signOut();

                  }
              ),
            SizedBox(height: 10.0),

            Visibility(
              // visible: (userfile.willToPay!=true),
              child: Column(
                children: [
                  Padding(
                       padding: const EdgeInsets.only(left: 40.0, right:40.0),
                    child: Divider(
                                    color: Colors.black,
                                    height: 50,
                                  ),
                  ),

            SizedBox(height: 10.0),

            Text(
            "Ryta Premium:",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
           
            SizedBox(height: 15.0),
            
            Padding(
              padding: const EdgeInsets.only(left:20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    // checkColor: Color(0xFFF9A825),
                    activeColor: Color(0xFFF9A825),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right:8.0),
                      child: Text('Get practical', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                    ),
                    subtitle: Text('connect Ryta to your Calendar, ToDo list...', style: TextStyle(fontSize: 17.0)),
                    value: _checkboxListTile1,
                    onChanged: (value) {
                      setState(() {
                        if(userfile.willToPay!=true) {
                        _checkboxListTile1 = !_checkboxListTile1;
                        if (_checkboxListTile1==true)
                        price=price+1;
                        if (_checkboxListTile1==false)
                        price=price-1;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    // checkColor: Color(0xFFF9A825),
                    activeColor: Color(0xFFF9A825),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right:8.0),
                      child: Text('Personalize', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                    ),
                    subtitle: Text('personal pictures, favorite quote, design...', style: TextStyle(fontSize: 17.0)),
                    value: _checkboxListTile2,
                    onChanged: (value) {
                      setState(() {
                        if(userfile.willToPay!=true) {
                        _checkboxListTile2 = !_checkboxListTile2;
                        if (_checkboxListTile2==true)
                        price=price+1;
                        if (_checkboxListTile2==false)
                        price=price-1;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    // checkColor: Color(0xFFF9A825),
                    activeColor: Color(0xFFF9A825),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right:8.0),
                      child: Text('Push yourself', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                    ),
                    subtitle: Text('Smart push notification, timer...', style: TextStyle(fontSize: 17.0)),
                    value: _checkboxListTile3,
                    onChanged: (value) {
                      setState(() {
                        if(userfile.willToPay!=true) {
                        _checkboxListTile3 = !_checkboxListTile3;
                        if (_checkboxListTile3==true)
                        price=price+1;
                        if (_checkboxListTile3==false)
                        price=price-1;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    // checkColor: Color(0xFFF9A825),
                    activeColor: Color(0xFFF9A825),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right:8.0),
                      child: Text('Get the most out of your data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                    ),
                    subtitle: Text('Connect your favourite Apps and let Ryta analyze the data...', style: TextStyle(fontSize: 17.0)),
                    value: _checkboxListTile4,
                    onChanged: (value) {
                      setState(() {
                        if(userfile.willToPay!=true) {
                        _checkboxListTile4 = !_checkboxListTile4;
                        if (_checkboxListTile4==true)
                        price=price+1;
                        if (_checkboxListTile4==false)
                        price=price-1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 15.0),
            
            Text(
              "$price.99 EUR",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 25.0),
              ),
            
            SizedBox(height: 20.0),
            
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(0),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF9A825)),
              ),
              child: Text(
                'UPGRADE TO PREMIUM',
                style: TextStyle(fontWeight: FontWeight.bold)
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
              if(userfile.willToPay!=true)
              // Set willToPay to True
              DatabaseService(uid: user.uid).updateUserWillingnessToPay(true,_checkboxListTile1, _checkboxListTile2, _checkboxListTile3, _checkboxListTile4, price);


                  }
              ),
              
              SizedBox(height: 40.0),
                              ],
              ),
            ),
              ],
              ),
            ),
          ],
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