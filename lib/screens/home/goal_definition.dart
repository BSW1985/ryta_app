import 'package:flutter/material.dart';
import 'package:ryta_app/screens/home/goal_image_search.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';

class GoalDefinition extends StatefulWidget {
  @override
  _GoalDefinitionState createState() => _GoalDefinitionState();
}

class _GoalDefinitionState extends State<GoalDefinition> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String goalname = '';
  String goalmotivation = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
                leading: new IconButton(
                      icon: new Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(
                          context,
                          // MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                centerTitle: true,
                title: SizedBox(
                    height: 70,
                    child: Image.asset("assets/ryta_logo.png"),),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text('New to Ryta? Sign in!'),
      // ),
      body: 
      
      // ListView(
      //   padding: EdgeInsets.symmetric(horizontal: 70.0),
      //   children: [
      //     SizedBox(height: 150.0),

          // Image.asset("assets/ryta_logo.png"),

          ListView(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              children: [
              Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Input email (panel)
                  SizedBox(height: 50.0),
                  Text(
                    "What is your goal/target?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'The target'),
                    validator: (val) => val.isEmpty ? 'Enter the target title' : null,
                    onChanged: (val) {
                      setState(() => goalname = val);
                    }
                  ),
                  // Input password (panel)
                  SizedBox(height: 30.0),
                  Text(
                    "Why do you want to achieve/reach it?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: textInputDecoration.copyWith(hintText: 'Your motivation'),
                    validator: (val) => val.isEmpty ? 'Your motivation is important part of the definition!' : null,
                    onChanged: (val) {
                      setState(() => goalmotivation = val);
                    }
                  ),
                  // Implementation of the log in button.
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text(
                      "CONTINUE",
                      //style: TextStyle(color: Colors.white),
                      ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GoalImageSearch()));
                        }
            
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