import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend_mobile/config.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'pages/inbox.dart';

User usr;

Future<String> requestChatID(int userID1, int userID2) async {
  var queryParameters = {
    'UserID1': userID1.toString(),
    'UserID2': userID2.toString()
  };
  var uri = Uri.http(
      '192.168.1.3:3000', '/Chat/GetChatBetweenUsers', queryParameters);
  var response = await http.get(uri);
  return response.body;
}
/*
Future<http.Response> publishMessage(Message msg) {
  return http.post(
    Uri.http('192.168.1.3:3000', '/Message/AddMessage'),
    body: jsonEncode(<String, String>{
      'id': msg.id.toString(),
      'chatId': msg.sender.chatID.toString(),
      'fromId': msg.sender.id.toString(),
      'messageText': msg.text,
      'timestamp': msg.time,
      'statusRead': msg.unread.toString()
    }),
  );
}*/

Future<http.Response> publishMessage(Message msg) async {
  final String apiURL = "http://192.168.1.3:3000/Message/AddMessage";
  final response = await http.post(apiURL,
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': msg.id.toString(),
        'chatId': msg.sender.chatID.toString(),
        'fromId': msg.sender.id.toString(),
        'messageText': msg.text,
        'timestamp': msg.time,
        'statusRead': msg.unread
      }));
  return response;
}

void setMessageReadStatus(int id, bool readStatus) async {
  var queryParameters = {
    'IDMessage': id.toString(),
    'status': readStatus.toString()
  };
  var uri = Uri.http(
      '192.168.1.3:3000', '/Message/ChangeStatusRead', queryParameters);
  await http.get(uri);
}

Future<String> requestGetChat(int id) async {
  var queryParameters = {'id': id.toString()};
  var uri =
      Uri.http('192.168.1.3:3000', '/Chat/GetChatsFromUserID', queryParameters);
  var response = await http.get(uri);
  return response.body;
}

Future<String> requestLatestMessageFromChat(int chatID) async {
  var queryParameters = {'chatID': chatID.toString()};
  var uri = Uri.http('192.168.1.3:3000', '/Message/GetLatestMessageFromChatID',
      queryParameters);
  var response = await http.get(uri);
  return response.body;
}

Future<String> requestAllMessagesFromChat(int chatID) async {
  var queryParameters = {'messageChatID': chatID.toString()};
  var uri = Uri.http(
      '192.168.1.3:3000', '/Message/GetAllMessagesFromChatID', queryParameters);
  var response = await http.get(uri);
  return response.body;
}

Future<String> asyncFileUpload(Uint8List contents) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://ipfs.infura.io:5001/api/v0/add'));
  // ignore: await_only_futures
  var pic = await http.MultipartFile.fromBytes('file', contents);
  request.files.add(pic);
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  return jsonDecode(responseString)['Hash'];
}

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
  User vendor;
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
      this.userInfo,
      this.vendor})
      : super(
            id: id,
            assetUrls: assetUrls,
            name: name,
            price: price,
            classification: classification,
            quantifier: quantifier);
}

class User {
  int id;
  String name;
  String surname;
  String privateKey;
  String metamaskAddress;
  String photoUrl;
  String desc;
  String email;
  String phoneNumber;
  String homeAddress;
  String birthday;
  int uType;
  // TODO add rating
  User(
      {this.id,
      this.name,
      this.surname,
      this.privateKey,
      this.metamaskAddress,
      this.photoUrl,
      this.desc,
      this.email,
      this.phoneNumber,
      this.homeAddress,
      this.birthday,
      this.uType});
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
  int cartQuantity, id, vendorId;

  CartProduct(
      {this.id,
      this.vendorId,
      this.photoUrl,
      this.name,
      this.price,
      this.cartQuantity});
}

class UserReview extends User {
  String text;
  int stars;

  UserReview(
      {int id,
      String name,
      String surname,
      String privateKey,
      String metamaskAddress,
      String photoUrl,
      String desc,
      String email,
      String phoneNumber,
      String homeAddress,
      String birthday,
      int uType,
      this.text,
      this.stars})
      : super(
          name: name,
          surname: surname,
          privateKey: privateKey,
          metamaskAddress: metamaskAddress,
          photoUrl: photoUrl,
          desc: desc,
          email: email,
          phoneNumber: phoneNumber,
          homeAddress: homeAddress,
          birthday: birthday,
          uType: uType,
        );
}

class ReviewPage {
  double average;
  int reviewsCount;
  List<int> stars;
  List<UserReview> reviews;
  ReviewPage({this.average, this.reviews, this.reviewsCount, this.stars});
}

class Order {
  int id;
  int productId;
  int amount;
  DateTime date;
  int status; //  confirmed, delivered, refunded, rejected
  int buyerId;
  int sellerId;
  String deliveryAddress;
  int paymentType;
  Order(
      {this.id,
      this.productId,
      this.amount,
      this.status,
      this.buyerId,
      this.date,
      this.sellerId,
      this.deliveryAddress,
      this.paymentType});
}

String formattedDate = DateFormat('kk:mm').format(DateTime.now());

ChatUserInfo chatUserInfoFromJson(String str) =>
    ChatUserInfo.fromJson(json.decode(str));

String chatUserInfoToJson(ChatUserInfo data) => json.encode(data.toJson());

class ChatUserInfo {
  ChatUserInfo({
    this.id,
    this.metaMaskAddress,
    this.privateKey,
    this.firstName,
    this.lastName,
  });

  int id;
  String metaMaskAddress;
  String privateKey;
  String firstName;
  String lastName;

  factory ChatUserInfo.fromJson(Map<String, dynamic> json) => ChatUserInfo(
        id: json["id"],
        metaMaskAddress: json["metaMaskAddress"],
        privateKey: json["privateKey"],
        firstName: json["first_Name"],
        lastName: json["last_Name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "metaMaskAddress": metaMaskAddress,
        "privateKey": privateKey,
        "first_Name": firstName,
        "last_Name": lastName,
      };
}

ChatInfo chatInfoFromJson(String str) => ChatInfo.fromJson(json.decode(str));

String chatInfoToJson(ChatInfo data) => json.encode(data.toJson());

class ChatInfo {
  ChatInfo({
    this.id,
    this.idSender,
    this.idReciever,
  });

  int id;
  int idSender;
  int idReciever;

  factory ChatInfo.fromJson(Map<String, dynamic> json) => ChatInfo(
        id: json["id"],
        idSender: json["id_Sender"],
        idReciever: json["id_Reciever"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_Sender": idSender,
        "id_Reciever": idReciever,
      };
}

ChatMessageInfo chatMessageInfoFromJson(String str) =>
    ChatMessageInfo.fromJson(json.decode(str));

String chatMessageInfoToJson(ChatMessageInfo data) =>
    json.encode(data.toJson());

class ChatMessageInfo {
  ChatMessageInfo({
    this.id,
    this.chatId,
    this.fromId,
    this.messageText,
    this.timestamp,
    this.statusRead,
  });

  @override
  String toString() {
    return '[${this.id},${this.chatId},${this.fromId},${this.messageText},${this.timestamp},${this.statusRead}]';
  }

  int id;
  int chatId;
  int fromId;
  String messageText;
  DateTime timestamp;
  bool statusRead;

  factory ChatMessageInfo.fromJson(Map<String, dynamic> json) =>
      ChatMessageInfo(
        id: json["id"],
        chatId: json["chatId"],
        fromId: json["fromId"],
        messageText: json["messageText"],
        timestamp: DateTime.parse(json["timestamp"]),
        statusRead: json["statusRead"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "fromId": fromId,
        "messageText": messageText,
        "timestamp": timestamp.toIso8601String(),
        "statusRead": statusRead,
      };
}
