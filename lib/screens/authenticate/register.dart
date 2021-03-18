import 'package:flutter/material.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // final String rytaLogo = 'assets/ryta_logo.svg';

  // text field state
  String email = '';
  String password = '';
  String error = '';
  

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text('New to Ryta? Sign in!'),
      // ),
      body: 
      
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 150.0),
        children: [
          // SizedBox(height: 150.0),

          Image.asset("assets/ryta_logo.png"),

          // Implementation of .svg logo - not necessary for the MVP?
          // SvgPicture.asset(
          //   rytaLogo,
          //   placeholderBuilder: (context) => CircularProgressIndicator(),
          //   height: 30.0,
          // ),

          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Text('Ready to reach your targets?'),
                // Input email (panel)
                SizedBox(height: 30.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }
                ),
                // Input password (panel)
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }
                ),
                // Register button
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text(
                    'REGISTER',
                    //style: TextStyle(color: Colors.white),
                    ),
                  onPressed: () async {
                    // dynamic result = await _auth.signInAnon();
                    // if (result==null) {
                    //   print('error signing in');
                    // } else {
                    //   print('signed in');
                    //   print(result);
                    // }
                    // print(email);
                    // print(password);
                    if (_formKey.currentState.validate()) {
                      setState(() => loading=true);
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if (result==null){
                        setState(() {
                          error = 'please supply a valid email';
                          loading=false;
                        });
                      }
                      // print(email);
                      // print(password);
                    }
                  }
                  ),
                // Get back to the log in page (button)
                SizedBox(height: 2.0),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  child: Text(
                    'BACK TO LOGIN',
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
