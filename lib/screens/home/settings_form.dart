import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:ryta_app/widgets/settings.dart';
import 'package:url_launcher/url_launcher.dart';

///Showing a personal settings and info
class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  double price = 0;

  double oneThird = 0;

  bool _checkboxListTile1 = false;
  bool _checkboxListTile2 = false;
  bool _checkboxListTile3 = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RytaUser>(context);
    final userfile = Provider.of<UserFile>(context);

    if (userfile == null)
      return Loading(Colors.white, Color(0xFF995C75));
    else
      oneThird = num.parse((userfile.priceInitialized / 3).toStringAsFixed(3));

    if (userfile.willToPay == true) {
      _checkboxListTile1 = userfile.package1;
      _checkboxListTile2 = userfile.package2;
      _checkboxListTile3 = userfile.package3;
      // _checkboxListTile4 = userfile.package4;
      price = userfile.price;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      // disabling a scroll glow
      // ignore: missing_return
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            // SizedBox(height: 20.0),
            // username
            Form(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 55.0, bottom: 20.0, left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),

                            SizedBox(height: 15.0),
                            // email
                            Text(
                              user.email,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Color(0xFF995C75),
                          ),
                          tooltip: 'Settings',
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Settings(userfile),
                              ),
                            );
                          },
                        ),
                      ),
                      // SizedBox(height: 10.0),
                    ],
                  ),
                  Visibility(
                    // visible: (userfile.willToPay!=true),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 40.0, right: 40.0),
                          child: Divider(
                            color: Colors.black,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Ryta Premium:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0),
                        ),
                        SizedBox(height: 15.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: <Widget>[
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                // checkColor: Color(0xFFF9A825),
                                activeColor: Color(0xFFF9A825),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0, right: 8.0),
                                  child: Text(
                                    'Get practical',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                subtitle: Text(
                                    'Connect Ryta to your calendar, add your ToDo-lists.',
                                    style: TextStyle(fontSize: 17.0)),
                                value: _checkboxListTile1,
                                onChanged: (value) {
                                  setState(() {
                                    if (userfile.willToPay != true) {
                                      _checkboxListTile1 = !_checkboxListTile1;
                                      if (_checkboxListTile1 == true)
                                        price = price + oneThird;
                                      if (_checkboxListTile1 == false)
                                        price = price - oneThird;
                                    }
                                  });
                                },
                              ),
                              // CheckboxListTile(
                              //   controlAffinity: ListTileControlAffinity.leading,
                              //   // checkColor: Color(0xFFF9A825),
                              //   activeColor: Color(0xFFF9A825),
                              //   title: Padding(
                              //     padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right:8.0),
                              //     child: Text('Personalize', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                              //   ),
                              //   subtitle: Text('personal pictures, favorite quote, design...', style: TextStyle(fontSize: 17.0)),
                              //   value: _checkboxListTile2,
                              //   onChanged: (value) {
                              //     setState(() {
                              //       if(userfile.willToPay!=true) {
                              //       _checkboxListTile2 = !_checkboxListTile2;
                              //       if (_checkboxListTile2==true)
                              //       price=price+1;
                              //       if (_checkboxListTile2==false)
                              //       price=price-1;
                              //       }
                              //     });
                              //   },
                              // ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                // checkColor: Color(0xFFF9A825),
                                activeColor: Color(0xFFF9A825),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0, right: 8.0),
                                  child: Text(
                                    'Push yourself',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                subtitle: Text(
                                    'Smart push notifications and a timer for your targets, so you never lose track of them.',
                                    style: TextStyle(fontSize: 17.0)),
                                value: _checkboxListTile2,
                                onChanged: (value) {
                                  setState(() {
                                    if (userfile.willToPay != true) {
                                      _checkboxListTile2 = !_checkboxListTile2;
                                      if (_checkboxListTile2 == true)
                                        price = price + oneThird;
                                      if (_checkboxListTile2 == false)
                                        price = price - oneThird;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                // checkColor: Color(0xFFF9A825),
                                activeColor: Color(0xFFF9A825),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0, right: 8.0),
                                  child: Text(
                                    'Get the most out of your data',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                subtitle: Text(
                                    "Combine the data of your favorite apps with Ryta. Ryta's analysis will show you the way to your targets/ Ryta's analysis will help you reach your targets",
                                    style: TextStyle(fontSize: 17.0)),
                                value: _checkboxListTile3,
                                onChanged: (value) {
                                  setState(() {
                                    if (userfile.willToPay != true) {
                                      _checkboxListTile3 = !_checkboxListTile3;
                                      if (_checkboxListTile3 == true)
                                        price = price + oneThird;
                                      if (_checkboxListTile3 == false)
                                        price = price - oneThird;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          (num.parse((price).toStringAsFixed(2))).abs() == 1.0
                              ? "0.99 EUR per month"
                              : "${(num.parse((price).toStringAsFixed(2))).abs()} EUR per month",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 20.0),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              backgroundColor: (_checkboxListTile1 == false &&
                                      _checkboxListTile2 == false &&
                                      _checkboxListTile3 == false)
                                  ? MaterialStateProperty.all<Color>(
                                      Colors.grey)
                                  : MaterialStateProperty.all<Color>(
                                      Color(0xFFF9A825)),
                            ),
                            child: Text('UPGRADE TO PREMIUM',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (_checkboxListTile1 == false &&
                                  _checkboxListTile2 == false &&
                                  _checkboxListTile3 == false) {
                                return null;
                              } else
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    title: Row(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                          Icons.thumb_up_alt,
                                          color: Color(0xFFF9A825),
                                          size: 40.0,
                                        ),
                                      ),
                                      Flexible(
                                          child: Text(
                                              'We are doing our best to make these features available!')),
                                    ]),
                                    content: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "We appreciate your interest! If you like our vision, have other ideas or would like to give us personal feedback, please contact us at ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'CenturyGothic'),
                                        ),

                                        // ignore: todo
                                        // TODO: make the link work!!!
                                        TextSpan(
                                            text: "info@ryta.eu",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'CenturyGothic'),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                var url =
                                                    'https://www.ryta.eu/';
                                                if (await canLaunch(url)) {
                                                  await launch(url.toString());
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              }),
                                        TextSpan(
                                          text: ". Your Ryta team :)",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'CenturyGothic'),
                                        ),
                                      ]),
                                    ),
                                    // actions: <Widget>[
                                    //   TextButton(
                                    //     child: Text('Back to the app'),
                                    //     onPressed: (){
                                    //       Navigator.of(context).pop();
                                    //     }
                                    //   ),
                                    // ],
                                  ),
                                );
                              if (userfile.willToPay != true)
                                // Set willToPay to True
                                DatabaseService(uid: user.uid)
                                    .updateUserWillingnessToPay(
                                        true,
                                        _checkboxListTile1,
                                        _checkboxListTile2,
                                        _checkboxListTile3,
                                        num.parse((price).toStringAsFixed(2)));
                            }),
                        SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
