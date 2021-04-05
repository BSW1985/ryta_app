import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Simple loading screen
class Loading extends StatelessWidget {

  final Color color;
  Loading(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Rose Dust Color Color(0xFF995C75)
      color: color, //background color
      child: Center(
        child: SpinKitThreeBounce(
          color: Color(0xFF995C75),
          size: 30.0,
        ),
      ), 
    );
  }
}