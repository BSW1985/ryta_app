import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ryta_app/services/auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  StreamProvider<RytaUser>.value(
      initialData: null, //???
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
        ),
      ),
    );  
  }
}
