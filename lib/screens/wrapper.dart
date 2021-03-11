import 'package:flutter/material.dart';
import 'package:ryta_app/screens/authenticate/authenticate.dart';
import 'package:ryta_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // return either home or authenticate widget
    return Authenticate();
  }
}