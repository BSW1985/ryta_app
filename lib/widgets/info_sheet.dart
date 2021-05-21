import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ryta_app/models/image_location.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

/// Bottom-sheet displaying info for a given [image].
class InfoSheet extends StatelessWidget {
  final UnsplashImage image;

  InfoSheet(this.image);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 3.0),
        // elevation: 10.0,
        // shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0)),
        // ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: image != null
                ? <Widget>[
                    InkWell(
                      onTap: () => launch(image?.getUser()?.getHtmlLink()),
                      child: Row(
                        children: <Widget>[
                          _buildUserProfileImage(
                              image?.getUser()?.getMediumProfileImage()),
                          Text(
                            '${image.getUser().getFirstName()} ${image.getUser().getLastName() == null ? "" : image.getUser().getLastName()}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              '${image.createdAtFormatted()}'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // show description
                    _buildDescriptionWidget(image.getDescription()),
                    // show location
                    _buildLocationWidget(image.getLocation()),
                    // attribute Unsplash
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "from ",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'CenturyGothic',
                                fontSize: 12.0),
                          ),
                          TextSpan(
                              text: "Unsplash",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'CenturyGothic',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url =
                                      'https://unsplash.com/?utm_source=Ryta_App&utm_medium=referral';
                                  if (await canLaunch(url)) {
                                    await launch(url.toString());
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                }),
                        ])),
                      ),
                    ),
                    // filter null views
                  ].where((w) => w != null).toList()
                : <Widget>[Loading(Colors.white, Color(0xFF995C75))]),
        decoration: new BoxDecoration(
          color: Colors.grey[50],
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
          ),
        ),
      );

  /// Builds a round image widget displaying a profile image from a given [url].
  Widget _buildUserProfileImage(String url) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      );

  /// Builds widget displaying a given [description] for an image.
  Widget _buildDescriptionWidget(String description) => description != null
      ? Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 3.0, bottom: 16.0),
          child: Text(
            '$description',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 15.0,
              letterSpacing: 0.1,
            ),
          ),
        )
      : null;

  /// Builds a widget displaying the [location], where the image was captured.
  Widget _buildLocationWidget(Location location) => location.getCity() != null
      ? Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black54,
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '${location.getCity()}, ${location.getCountry()}'
                        .toUpperCase(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        )
      : null;
}
