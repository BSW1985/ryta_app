import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/home.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/constants.dart';

class EditGoal extends StatefulWidget {
  final String imageId, imageUrl;
  final Goal goal;
  final int index;

  EditGoal(this.index, this.goal, this.imageId, this.imageUrl, {Key key})
      : super(key: key);

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String goalname = '';
  String goalmotivation = '';
  String error = '';

  /// Displayed image.
  UnsplashImage image;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RytaUser>(context);
    if (goalname == "") goalname = widget.goal.goalname;
    if (goalmotivation == "") goalmotivation = widget.goal.goalmotivation;

    return Container(
      color: Colors.transparent,
      // margin:
      //     EdgeInsets.only(top: 5),
      height: 450, //450
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Flexible(flex: 1, child: SizedBox(height: 5.0)),

                      Text(
                        "Edit the target",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.grey),
                      ),

                      Flexible(flex: 1, child: SizedBox(height: 30.0)),
                      Text(
                        "Title",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),

                      Flexible(flex: 1, child: SizedBox(height: 15.0)),
                      TextFormField(
                          maxLength: 50,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: textInputDecoration.copyWith(
                              hintText: widget.goal.goalname),
                          onChanged: (val) {
                            setState(() => goalname = val);
                          }),

                      // Input goal motivation
                      Flexible(flex: 1, child: SizedBox(height: 25.0)),
                      Text(
                        "Motivation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),

                      Flexible(flex: 1, child: SizedBox(height: 15.0)),
                      TextFormField(
                          maxLength: 150,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: textInputDecoration.copyWith(
                              hintText: widget.goal.goalmotivation),
                          onChanged: (val) {
                            setState(() => goalmotivation = val);
                          }),

                      // Implementation of the continue in button.
                      Flexible(flex: 1, child: SizedBox(height: 25.0)),
                      ElevatedButton(
                          child: Text(
                            "CONTINUE",
                            //style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            //// Edit the goal in Firestore
                            await DatabaseService(uid: user.uid).editUserGoals(
                                widget.index,
                                goalname,
                                goalmotivation,
                                widget
                                    .imageUrl); // widget.goal.goalname = goalname;

                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          }),
                    ]),
                  ),
                ),
              ),
            )
          ]),
    );
  }
}
