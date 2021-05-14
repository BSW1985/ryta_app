import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // final String rytaLogo = 'assets/ryta_logo.svg';

  // text field state
  String username = '';
  String email = '';
  String password = '';
  String password2 = '';
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
                SizedBox(height: 60.0),

                Image.asset(
                  "assets/ryta_logo.png",
                  height: 150,
                  // width: 100,
                ),

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
                      // SizedBox(height: 10.0),
                      Text(
                        'Ready to reach your targets?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      // Input email (panel)
                      SizedBox(height: 30.0),
                      TextFormField(
                          initialValue: username,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Firstname/Nickname'),
                          validator: (val) => val.isEmpty
                              ? 'Enter your name or nickname'
                              : null,
                          onChanged: (val) {
                            setState(() => username = val);
                          }),
                      // Input password (panel)
                      SizedBox(height: 10.0),
                      TextFormField(
                          initialValue: email,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]'))
                          ],
                          keyboardType: TextInputType.text,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email address' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      // Input password (panel)
                      SizedBox(height: 10.0),
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              errorMaxLines: 3, hintText: 'Password'),
                          validator: (val) {
                            if (val.length < 6) {
                              return "Enter a password 6+ characters long, with at least one upper case letter, lower case letter and one digit";
                            } else if (!val.contains(new RegExp(r'[A-Z]'))) {
                              return "Enter a password 6+ characters long, with at least one upper case letter, lower case letter and one digit";
                            } else if (!val.contains(new RegExp(r'[0-9]'))) {
                              return "Enter a password 6+ characters long, with at least one upper case letter, lower case letter and one digit";
                            } else if (!val.contains(new RegExp(r'[a-z]'))) {
                              return "Enter a password 6+ characters long, with at least one upper case letter, lower case letter and one digit";
                              // } else if (!val.contains(
                              //     new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              //   return "Use a special character";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      SizedBox(height: 10.0),
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Confirm password'),
                          validator: (val) => val != password
                              ? 'Passwords are not the same'
                              : null,
                          onChanged: (val) {
                            setState(() => password2 = val);
                          }),
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
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, username);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Email adress already exists or is not valid';
                                  loading = false;
                                });
                              }
                              // print(email);
                              // print(password);
                            }
                          }),
                      // Get back to the log in page (button)
                      SizedBox(height: 2.0),
                      ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15.0)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            //         side: BorderSide(color: Colors.grey, width: 1.0),
                            //         borderRadius: BorderRadius.circular(15.0))),
                          ),
                          child: Text(
                            'BACK TO LOGIN',
                            //style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            widget.toggleView();
                          }),
                      SizedBox(height: 5.0),
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
