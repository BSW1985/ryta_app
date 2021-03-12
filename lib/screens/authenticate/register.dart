import 'package:flutter/material.dart';
import 'package:ryta_app/services/auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';

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
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Text('Register'),
                SizedBox(height: 30.0),
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
                  onChanged: (val) {
                    setState(() => email = val);
                  }
                ),
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
                  onChanged: (val) {
                    setState(() => password = val);
                  }
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[800]) ),
                  child: Text(
                    'Register',
                    //style: TextStyle(color: Colors.white),
                    ),
                  onPressed: () async {
                    print(email);
                    print(password);
          
                  }
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}