import 'package:frontend_mobile/config.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void performPayment(String targetAccountAddress, int eth) async {
  final client =
      Web3Client('http://' + HOST, Client(), enableBackgroundIsolate: true);
  final credentials = await client.credentialsFromPrivateKey(PRIVATE_KEY);

  await client.sendTransaction(
    credentials,
    Transaction(
      to: EthereumAddress.fromHex(targetAccountAddress),
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, eth),
    ),
    fetchChainIdFromNetworkId: false,
  );
  await client.dispose();
}

class Prefs {
  Prefs._privateConstructor();

  static final Prefs instance = Prefs._privateConstructor();

  setStringValue(String key, String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "";
  }

  setIntegerValue(String key, int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt(key, value);
  }

  Future<int> getIntegerValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt(key) ?? 0;
  }

  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.containsKey(key);
  }

  removeValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(key);
  }

  removeAll() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }
}

enum Classification { Single, Weight, Volume }

class ProductEntry {
  int id;
  List<String> assetUrls;
  String name;
  double price;
  Classification classification;
  int quantifier;
  String desc;
  int sellerId;
  int categoryId;
  ProductEntry(
      {this.id,
      this.assetUrls,
      this.name,
      this.price,
      this.classification,
      this.quantifier,
      this.desc,
      this.sellerId,
      this.categoryId});
}

class DiscountedProductEntry extends ProductEntry {
  double prevPrice;

  DiscountedProductEntry(
      {List<String> assetUrls,
      String name,
      double price,
      double prevPrice,
      Classification classification,
      int quantifier})
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
  int id;
  String assetUrl;
  String name;

  Category({this.id, this.name, this.assetUrl});
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
  double averageReviewScore;
  int numberOfReviews;
  UserInfo userInfo;

  ProductEntryListingPage(
      {List<String> assetUrls,
      String name,
      double price,
      Classification classification,
      int quantifier,
      int id,
      this.description,
      this.averageReviewScore,
      this.numberOfReviews,
      this.userInfo})
      : super(
            id: id,
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

class Review {
  int id;
  int productId;
  int rating;
  String desc;
  int userId;

  Review({this.id, this.productId, this.rating, this.desc, this.userId});
}

class CartProduct {
  List<String> photoUrl;
  String name;
  double price;
  int cartQuantity, id;

  CartProduct(
      {this.id, this.photoUrl, this.name, this.price, this.cartQuantity});
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
  ChatMessage({this.messageContent, this.messageType});
}

class Order {
  int id;
  List<int> productIds;
  double price;
  DateTime date;
  int status; //  confirmed, delivered, refunded, rejected
  int buyerId;
  Order(
      {this.id,
      this.productIds,
      this.status,
      this.buyerId,
      this.price,
      this.date});
}
