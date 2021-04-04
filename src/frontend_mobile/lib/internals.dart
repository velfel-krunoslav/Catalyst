import 'package:flutter/cupertino.dart';

enum Classification { Single, Weight, Volume }

class ProductEntry {
  List<String> assetUrls;
  String name;
  double price;
  Classification classification;
  double quantifier;

  ProductEntry(
      {this.assetUrls,
      this.name,
      this.price,
      this.classification,
      this.quantifier});
}

class DiscountedProductEntry extends ProductEntry {
  double prevPrice;

  DiscountedProductEntry(
      {List<String> assetUrls,
      String name,
      double price,
      double prevPrice,
      Classification classification,
      double quantifier})
      : super(
            assetUrls: assetUrls,
            name: name,
            price: price,
            classification: classification,
            quantifier: quantifier) {
    this.prevPrice = prevPrice;
  }
}

class Category {
  String assetUrl;
  String name;

  Category({this.name, this.assetUrl});
}

class UserInfo {
  String profilePictureAssetUrl;
  String fullName;
  int reputationPositive;
  int reputationNegative;

  UserInfo(
      {this.profilePictureAssetUrl,
      this.fullName,
      this.reputationNegative,
      this.reputationPositive});
}

class ProductEntryListingPage extends ProductEntry {
  String description;
  int averageReviewScore;
  int numberOfReviews;
  UserInfo userInfo;

  ProductEntryListingPage(
      {List<String> assetUrls,
      String name,
      double price,
      Classification classification,
      double quantifier,
      this.description,
      this.averageReviewScore,
      this.numberOfReviews,
      this.userInfo})
      : super(
            assetUrls: assetUrls,
            name: name,
            price: price,
            classification: classification,
            quantifier: quantifier);
}

class User {
  String forename;
  String surname;
  String photoUrl;
  String phoneNumber;
  String address;
  String city;
  String mail;
  String about;
  double rating;
  int reviewsCount;

  User(
      {this.forename,
      this.surname,
      this.photoUrl,
      this.phoneNumber,
      this.address,
      this.city,
      this.mail,
      this.about,
      this.rating,
      this.reviewsCount});
}

class UserReview extends User {
  String text;
  int stars;

  UserReview(
      {String forename,
      String surname,
      String photoUrl,
      String phoneNumber,
      String address,
      String city,
      String mail,
      String about,
      double rating,
      int reviewsCount,
      this.text,
      this.stars})
      : super(
            forename: forename,
            surname: surname,
            photoUrl: photoUrl,
            phoneNumber: phoneNumber,
            address: address,
            city: city,
            mail: mail,
            about: about,
            rating: rating,
            reviewsCount: reviewsCount);
}

class ReviewPage {
  double average;
  int reviewsCount;
  List<int> stars;
  List<UserReview> reviews;

  ReviewPage({this.average, this.reviews, this.reviewsCount, this.stars});
}

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUsers({this.name, this.messageText, this.imageURL, this.time});
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}
