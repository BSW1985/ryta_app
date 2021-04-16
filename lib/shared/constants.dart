import 'package:flutter/material.dart';

// Text Input Theme
const textInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(11.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF9A825), width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(11.0)),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
);
