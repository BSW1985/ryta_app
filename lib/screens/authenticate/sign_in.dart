import 'package:flutter/material.dart';
import 'package:ryta_app/services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text('New to Ryta? Sign in!'),
      // ),
      body: 
      
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 70.0),
        children: [
          SizedBox(height: 150.0),

          Image.asset("assets/ryta_logo.png"),

          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Input email (panel)
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    border:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow[800], width: 3.0),
                    ),
                    hintText: 'Email',
                    contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }
                ),
                // Input password (panel)
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow[800], width: 3.0),
                    ),
                    hintText: 'Password',
                    contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }
                ),
                // Implementation of the log in button.
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[800]) ),
                  child: Text(
                    'LOG IN',
                    //style: TextStyle(color: Colors.white),
                    ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result==null){
                        setState(() => error = 'could not sign in with those credentials');
                      }
                    }
          
                  }
                  ),
                // Implementation of the register button.
                SizedBox(height: 2.0),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  child: Text(
                    'REGISTER',
                    //style: TextStyle(color: Colors.white),
                    ),
                  onPressed: () {
                    widget.toggleView();
                  }
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize:14.0),
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
