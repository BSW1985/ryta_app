import 'package:date_format/date_format.dart';
import 'package:ryta_app/models/image_location.dart';
import 'package:ryta_app/models/unsplash_user.dart';

/// Model for Unsplash Image
class UnsplashImage {
  var data;

  UnsplashImage(this.data);

  // Getter
  String getId() {
    return data['id'];
  }

  String createdAt() {
    return data['created_at'];
  }

  String createdAtFormatted() {
    return formatDate(DateTime.parse(createdAt()), [dd, '. ', M, ' ', yyyy]);
  }

  String updatedAt() {
    return data['updated_at'];
  }

  Location getLocation() {
    return data['location'] != null ? Location(data['location']) : null;
  }

  int getWidth() {
    return data['width'];
  }

  int getHeight() {
    return data['height'];
  }

  String getColor() {
    return data['color'];
  }

  int getLikes() {
    return data['likes'];
  }

  bool isLikedByUser() {
    return data['liked_by_user'];
  }

  String getDescription() {
    return data['description'];
  }

  String getAltDescription() {
    return data['alt_description'];
  }

  UnsplashUser getUser() {
    return UnsplashUser(data['user']);
  }

  getUrls() {
    return data['urls'];
  }

  String getRawUrl() {
    return getUrls()['raw'];
  }

  String getFullUrl() {
    return getUrls()['full'];
  }

  String getRegularUrl() {
    return getUrls()['regular'];
  }

  String getSmallUrl() {
    return getUrls()['small'];
  }

  String getThumbUrl() {
    return getUrls()['thumb'];
  }

  getLinks() {
    return data['links'];
  }

  String getSelfLink() {
    return getLinks()['self'];
  }

  String getHtmlLink() {
    return getLinks()['html'];
  }

  String getDownloadLink() {
    return getLinks()['download'];
  }
}
