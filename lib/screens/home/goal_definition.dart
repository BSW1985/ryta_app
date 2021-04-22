import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/screens/home/goal_image_search.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';

// first screen of the goal definition process
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
    final goal = Provider.of<Goal>(context);

    return loading
        ? Loading(Colors.white, Color(0xFF995C75))
        : Scaffold(
            backgroundColor: Colors.white,
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
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Input goal name
                      SizedBox(height: 50.0),
                      Text(
                        "What is your target?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                          maxLength: 50,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'The target'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter the target title' : null,
                          onChanged: (val) {
                            setState(() => goalname = val);
                          }),
                      // Input goal motivation
                      SizedBox(height: 25.0),
                      Text(
                        "Why do you want to reach it?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                          maxLength: 150,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Your motivation'),
                          validator: (val) => val.isEmpty
                              ? 'Your motivation is important part of the definition!'
                              : null,
                          onChanged: (val) {
                            setState(() => goalmotivation = val);
                          }),
                      // Implementation of the continue in button.
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          child: Text(
                            "CONTINUE",
                            //style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              goal.goalname = goalname;
                              goal.goalmotivation = goalmotivation;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GoalImageSearch(goalname)));
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
