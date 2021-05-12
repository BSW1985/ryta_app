import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
import 'package:ryta_app/screens/wrapper.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/constants.dart';

class Settings extends StatefulWidget {
  final UserFile userfile;

  Settings(this.userfile, {Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _newsletterSubscription = true;
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RytaUser>(context);
    // final userfile = Provider.of<UserFile>(context);

    if (widget.userfile == null)
      _newsletterSubscription = widget.userfile.newsletterSubscription;

    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: SizedBox(
          height: 70,
          child: Image.asset("assets/ryta_logo.png"),
        ),
      ),

      body: Container(
        color: Colors.white,
        // margin:
        //     EdgeInsets.only(top: 5),
        // height: 450,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15.0),
                Text(
                  "Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.grey),
                ),
                SizedBox(height: 20.0),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  // checkColor: Color(0xFFF9A825),
                  activeColor: Color(0xFFF9A825),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Text(
                      'Newsletter',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                  ),
                  // subtitle: Text(
                  //     'Stay on track with all the new stuff coming soon in Ryta!',
                  //     style: TextStyle(fontSize: 17.0)),
                  value: _newsletterSubscription,
                  onChanged: (value) async {
                    setState(() {
                      _newsletterSubscription = !_newsletterSubscription;
                    });

                    await DatabaseService(uid: user.uid)
                        .updateNewsletterSubscription(
                      _newsletterSubscription,
                    );

                    // Navigator.of(context, rootNavigator: true).pop();
                    //change the value in firestore
                  },
                ),
                Text(
                    'Stay on track with all the new stuff coming soon in Ryta!',
                    style: TextStyle(fontSize: 17.0)),
                SizedBox(height: 30.0),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0)),
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
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 20.0),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0))),
                    ),
                    child: Text(
                      'DELETE ACCOUNT',
                    ),
                    onPressed: () async {
                      //Ask if the user is sure?
                      showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                          title: new Text(
                              'Do you really want to delete your Ryta account?',
                              style: TextStyle(fontSize: 17.0)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("No"),
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF995C75)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () async {
                                //more user to archive and delete all the personal data...
                                dynamic f = await _auth.deleteUser();
                                //is reauthentication needed?
                                if (f != null)
                                  showDialog(
                                    context: context,
                                    builder: (context) => new AlertDialog(
                                      title: new Text(
                                          'Please enter your password to reauthenticate'),
                                      content: Form(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 10.0),
                                              TextFormField(
                                                  obscureText: true,
                                                  decoration:
                                                      textInputDecoration
                                                          .copyWith(
                                                              hintText:
                                                                  'Password'),
                                                  validator: (val) => val
                                                              .length <
                                                          6
                                                      ? 'Enter a valid password'
                                                      : null,
                                                  onChanged: (val) {
                                                    setState(
                                                        () => password = val);
                                                  }),
                                            ]),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              String email =
                                                  widget.userfile.email;

                                              // Create a credential
                                              EmailAuthCredential credential =
                                                  EmailAuthProvider.credential(
                                                      email: email,
                                                      password: password);
                                              dynamic result = await FirebaseAuth
                                                  .instance.currentUser
                                                  .reauthenticateWithCredential(
                                                      credential);

                                              if (result == null) {
                                                setState(() {
                                                  error =
                                                      'Password not correct';
                                                });
                                              }
                                            }
                                            //more user to archive and delete all the personal data...
                                            await _auth.deleteUser();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Wrapper()));
                                            //Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                            elevation: MaterialStateProperty
                                                .all<double>(0),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(10.0)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.transparent),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Color(0xFF995C75)),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xFF995C75),
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0))),
                                          ),
                                          child: Text("CONFIRM"),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          error,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  );

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()));
                                //Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF995C75)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFF995C75),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                              ),
                              child: Text("Yes"),
                            ),
                          ],
                        ),
                      );
                    }),

                // actions: <Widget>[
                //   TextButton(
                //     child: Text('Back to the app'),
                //     onPressed: (){
                //       Navigator.of(context).pop();
                //     }
              ]),
        ),
      ),
    );
  }
}
