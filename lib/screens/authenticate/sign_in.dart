import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading(Colors.white, Color(0xFF995C75))
        : Scaffold(
            backgroundColor: Colors.white,
            // appBar: AppBar(
            //   backgroundColor: Colors.blue,
            //   title: Text('New to Ryta? Sign in!'),
            // ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 45.0),
              children: [
                SizedBox(height: 100.0),
                Image.asset(
                  "assets/ryta_logo.png",
                  height: 150,
                  // width: 100,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Input email (panel)
                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      // Input password (panel)
                      SizedBox(height: 10.0),
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 8+ characters long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      // Implementation of the log in button.
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          child: Text(
                            'LOG IN',
                            //style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);

                              if (result == null) {
                                setState(() {
                                  error = 'Email or password not correct';
                                  loading = false;
                                });
                              }
                            }
                          }),
                      // Implementation of the register button.
                      SizedBox(height: 8.0),
                      ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15.0)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF995C75)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xFF995C75), width: 1.0),
                                    borderRadius: BorderRadius.circular(15.0))),
                          ),
                          child: Text(
                            'REGISTER',
                            //style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            widget.toggleView();
                          }),
                      Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 15.0),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                        Text("OR"),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                      ]),
                      SignInButton(
                        Buttons.Google,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.grey)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        text: "CONTINUE WITH GOOGLE",
                        onPressed: () {
                          //LOGIN USING GOOGLE HERE
                          Loading.showLoading(context);

                          // AuthService authService = new AuthService();
                          var user = _auth.googleSignIn();

                          //Pop the loading
                          Navigator.of(context).pop(false);

                          //Check if the login was successful
                          if (user == null)
                            // {
                            //Login failed
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: Text("Failed to log in!"),
                                  content: Text(
                                      "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new ElevatedButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          // } else {
                          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                          // }
                        },
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

// body: ListView(
//   padding: EdgeInsets.all(24),
//   children: [
//     //Sub title
//     Text(
//       "Login with Google\n\nThis helps us to save your preferences and make this app sync across devices",
//       textAlign: TextAlign.start,
//     ),

//     //Illustration
//     Image.asset("assets/images/levitate.gif"),

//     SizedBox(height: 50),

//     //Google Login button
//     Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         RaisedButton(
//           padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.network(
//                 "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-icon-png-transparent-background-osteopathy-16.png",
//                 height: 30,
//                 width: 30,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text("Login with Google", style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//           onPressed: () {
//             //LOGIN USING GOOGLE HERE
//             Utility.showLoading(context);

//             AuthService authService = new AuthService();
//             var user = authService.googleSignIn();

//             //Pop the loading
//             Navigator.of(context).pop(false);

//             //Check if the login was successful
//             if (user == null) {
//               //Login failed
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   // return object of type Dialog
//                   return AlertDialog(
//                     title: Text("Failed to log in!"),
//                     content: Text(
//                         "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
//                     actions: <Widget>[
//                       // usually buttons at the bottom of the dialog
//                       new FlatButton(
//                         child: new Text("Close"),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             } else {
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
//             }
//           },
//         ),
//       ],
//     ),
//   ],
// ),
