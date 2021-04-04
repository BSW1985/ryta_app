import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
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
    // Provider listens to changes in AuthService(). The data is streamed to the wrapper.
    return  StreamProvider<RytaUser>.value(
      initialData: null, //???
      value: AuthService().user,
      child: Provider<Goal>( // Provider listens for changes in goal definition and the data stream into all screens.
              create: (_) => Goal(),
              child: MaterialApp(
                  home: Wrapper(),
                  theme: ThemeData(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                    ),
                    // ElevatedButtonTheme
                    elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white, // Text color
                      primary: Color(0xFF995C75), // background color
                      padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
                      ),
                    ),
                  ),
                ),
      ),
    );  
  }
}
