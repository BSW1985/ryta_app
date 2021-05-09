import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/shared/constants.dart';

class ResetPassword extends StatefulWidget {
  final String emailInput;

  ResetPassword(this.emailInput, {Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String _email = "";
  String error = '';
  bool _newEmail = false;

  /// Displayed image.
  UnsplashImage image;

  @override
  Widget build(BuildContext context) {
    if (_email == "") _email = widget.emailInput;

    return Container(
      color: Colors.white,
      // margin:
      //     EdgeInsets.only(top: 5),
      // height: 250, //450
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                // height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 5.0),

                          Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.grey),
                          ),

                          SizedBox(height: 30.0),
                          Text(
                            "Enter your email",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),

                          SizedBox(height: 15.0),
                          TextFormField(
                              validator: (value) =>
                                  EmailValidator.validate(value)
                                      ? null
                                      : "Please enter a valid email",
                              decoration: textInputDecoration.copyWith(
                                  hintText: widget.emailInput),
                              onChanged: (val) {
                                setState(() => _email = val);
                                setState(() {
                                  _newEmail = true;
                                });
                              }),

                          // Input goal motivation
                          SizedBox(height: 25.0),
                          ElevatedButton(
                              child: Text(
                                "SUBMIT",
                                //style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_newEmail == false &&
                                    EmailValidator.validate(_email)) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.passwordReset(_email);

                                  if (result == null) {
                                    setState(() {
                                      error = 'No user account with this email';
                                      loading = false;
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                } else if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.passwordReset(_email);

                                  if (result == null) {
                                    setState(() {
                                      error = 'No user account with this email';
                                      loading = false;
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                }
                              }),
                          SizedBox(height: 10.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ]),
                  ),
                ),
              ),
            )
          ]),
    );
  }
}
