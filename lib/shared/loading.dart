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
  //Show loading pop up
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Loading(Colors.black),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: new Text("Loading, please wait..."),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}