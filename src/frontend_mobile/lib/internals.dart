import 'package:frontend_mobile/config.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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

  User({
    this.forename,
    this.surname,
    this.photoUrl,
    this.phoneNumber,
    this.address,
    this.city,
    this.mail,
    this.about,
    this.rating,
    this.reviewsCount,
  });
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

class ChatUser {
  int id;
  String name;
  String photoUrl;

  ChatUser({this.id, this.name, this.photoUrl});
}

class Message {
  final ChatUser sender;
  final String time;
  final String text;
  bool unread;

  Message({this.sender, this.time, this.text, this.unread});
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

ChatUser currentUser = ChatUser(
  id: 0,
  name: 'Trenutni user',
  photoUrl: 'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
);
ChatUser jelena = ChatUser(
  id: 1,
  name: 'Jelena',
  photoUrl: 'assets/avatars/avatar2.jpg',
);
ChatUser luka = ChatUser(
  id: 2,
  name: 'Luka',
  photoUrl: 'assets/avatars/avatar1.jpg',
);
ChatUser marija = ChatUser(
  id: 3,
  name: 'Marija',
  photoUrl: 'assets/avatars/avatar3.jpg',
);
ChatUser pera = ChatUser(
  id: 4,
  name: 'Slobodanka',
  photoUrl: 'assets/avatars/avatar4.jpg',
);
ChatUser krunoslav = ChatUser(
  id: 5,
  name: 'Krunoslav',
  photoUrl: 'assets/avatars/avatar5.jpg',
);
ChatUser stefan = ChatUser(
  id: 6,
  name: 'Stefan',
  photoUrl: 'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
);

List<ChatUser> contacts = [jelena, luka, marija, pera, krunoslav, stefan];

DateTime now = DateTime.now();
String formattedDate = DateFormat('kk:mm').format(now);

List<Message> chats = [
  Message(sender: jelena, time: formattedDate, text: 'Hey?', unread: true),
  Message(
      sender: luka,
      time: formattedDate,
      text: 'Jesam li parsirao?',
      unread: false),
  Message(
      sender: marija,
      time: formattedDate,
      text: 'Posto je paprika,druze?',
      unread: true),
  Message(sender: jelena, time: formattedDate, text: 'Desi?', unread: false),
  Message(
      sender: stefan,
      time: formattedDate,
      text: '.................',
      unread: false),
  Message(sender: krunoslav, time: formattedDate, text: 'stres', unread: true),
  Message(sender: pera, time: formattedDate, text: 'zdera', unread: false),
  Message(sender: jelena, time: formattedDate, text: 'Hey', unread: true),
  Message(sender: luka, time: formattedDate, text: 'Parsiraj', unread: false),
  Message(sender: marija, time: formattedDate, text: 'Aloee', unread: true),
  Message(sender: jelena, time: formattedDate, text: 'Desi', unread: false),
  Message(sender: stefan, time: formattedDate, text: '...', unread: false),
  Message(
      sender: krunoslav, time: formattedDate, text: 'helloouuu', unread: true),
  Message(
      sender: pera,
      time: formattedDate,
      text: 'Sta je bre ovo?',
      unread: false),
];

List<Message> messages = [
  Message(sender: luka, time: '5:30', text: 'Jesam li parsirao?', unread: true),
  Message(
      sender: currentUser, time: '5:30', text: 'Nisi parsirao!', unread: true),
  Message(
    sender: luka,
    time: '5:31',
    text: 'Posto paradajz?',
    unread: true,
  ),
  Message(
      sender: currentUser,
      time: '5:38',
      text: '150 dinara kilo!',
      unread: true),
  Message(
      sender: luka,
      time: '8:30',
      text: 'Skup si brate,moze popust?',
      unread: true),
  Message(
      sender: currentUser,
      time: '8:32',
      text: 'Moze,dajem 10% za tebe popusta!',
      unread: true),
  Message(
      sender: luka,
      time: '9:00',
      text:
          'Moze salji na sledecu adresu: Radoja Domanovica 1,Kragujevac,34000',
      unread: true),
  Message(sender: currentUser, time: '9:11', text: 'Dogovoreno!', unread: true),
];
