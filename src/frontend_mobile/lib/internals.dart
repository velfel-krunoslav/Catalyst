import 'dart:convert';
import 'dart:typed_data';
import './config.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'pages/inbox.dart';

User usr;

void switchToDarkTheme() {
  RED_ATTENTION = 0xFFCB1C04;
  GREEN_SUCCESSFUL = 0xFF33AE08;
  BLACK = 0xFF000000;
  DARK_GREY = 0xFFECECEC;
  LIGHT_GREY = 0xFF6D6D6D;
  DARK_GREEN = 0xFF07630B;
  MINT = 0xFF1BD14C;
  OLIVE = 0xFF009A29;
  TEAL = 0xFF0EAD65;
  CYAN = 0xFF0F62FE;
  LIGHT_BLACK = 0xFF202020;
  YELLOW = 0xFFE7A600;
  FOREGROUND = 0xFFFFFFFF;
  BACKGROUND = 0xFF000000;
}

void switchToLightTheme() {
  RED_ATTENTION = 0xFFCB1C04;
  GREEN_SUCCESSFUL = 0xFF33AE08;
  BLACK = 0xFF000000;
  DARK_GREY = 0xFF6D6D6D;
  LIGHT_GREY = 0xFFECECEC;
  DARK_GREEN = 0xFF07630B;
  MINT = 0xFF1BD14C;
  OLIVE = 0xFF009A29;
  TEAL = 0xFF0EAD65;
  CYAN = 0xFF0F62FE;
  LIGHT_BLACK = 0xFF202020;
  YELLOW = 0xFFE7A600;
  FOREGROUND = 0xFF000000;
  BACKGROUND = 0xFFFFFFFF;
}

Future<String> requestChatID(int userID1, int userID2) async {
  var queryParameters = {
    'UserID1': userID1.toString(),
    'UserID2': userID2.toString()
  };
  var uri = Uri.http('$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT',
      '/Chat/GetChatBetweenUsers', queryParameters);
  var response = await http.get(uri);
  return response.body;
}

Future<http.Response> publishMessage(Message msg) async {
  final String apiURL =
      "http://$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT/Message/AddMessage";
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
        'unread': msg.unread
      }));
  return response;
}

Future<http.Response> addChat({int idSender, int idReceiver}) async {
  final String apiURL =
      "http://$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT/Chat/AddChat";
  final response = await http.post(apiURL,
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, dynamic>{
        "id": 0,
        "id_Sender": idSender,
        "id_Reciever": idReceiver,
      }));
  return response;
}

void setMessageReadStatus(int id, bool readStatus) async {
  var queryParameters = {
    'IDMessage': id.toString(),
    'status': readStatus.toString()
  };
  var uri = Uri.http('$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT',
      '/Message/ChangeStatusRead', queryParameters);
  await http.get(uri);
}

Future<String> requestGetChat(int id) async {
  var queryParameters = {'id': id.toString()};
  var uri = Uri.http('$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT',
      '/Chat/GetChatsFromUserID', queryParameters);
  var response = await http.get(uri);
  return response.body;
}

Future<String> requestLatestMessageFromChat(int chatID) async {
  var queryParameters = {'chatID': chatID.toString()};
  var uri = Uri.http('$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT',
      '/Message/GetLatestMessageFromChatID', queryParameters);
  var response = await http.get(uri);
  return response.body;
}

Future<String> requestAllMessagesFromChat(int chatID) async {
  var queryParameters = {'messageChatID': chatID.toString()};
  var uri = Uri.http('$MESSAGING_SERVER_HOSTNAME:$MESSAGING_SERVER_PORT',
      '/Message/GetAllMessagesFromChatID', queryParameters);
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

Future<bool> performPayment(String privateKey, String targetAccountAddress,
    {dynamic eth, dynamic wei}) async {
  bool hasFault = false;
  final client =
      Web3Client('http://' + HOST, Client(), enableBackgroundIsolate: true);
  final credentials = await client
      .credentialsFromPrivateKey(privateKey)
      .onError((error, stackTrace) {
    hasFault = true;
  });
  String hash;
  hash = await client
      .sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(targetAccountAddress),
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 100000,
          value: (eth != null)
              ? EtherAmount.fromUnitAndValue(EtherUnit.ether, eth)
              : EtherAmount.fromUnitAndValue(EtherUnit.wei, wei),
        ),
        fetchChainIdFromNetworkId: false,
      )
      .onError((error, stackTrace) => hash = null);

  if (hash == null || hasFault) return false;

  var res = await client
      .getTransactionReceipt(hash)
      .whenComplete(() => client.dispose());

  return res.status;
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
  int discountPercentage;
  Classification classification;
  int quantifier;
  String desc;
  int sellerId;
  int categoryId;
  int inStock;
  ProductEntry(
      {this.id,
      this.assetUrls,
      this.name,
      this.price,
      this.discountPercentage,
      this.classification,
      this.quantifier,
      this.desc,
      this.sellerId,
      this.categoryId,
      this.inStock});
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
      int discountPercentage,
      int categoryId,
      int inStock,
      this.description,
      this.averageReviewScore,
      this.numberOfReviews,
      this.userInfo,
      this.vendor})
      : super(
            inStock: inStock,
            categoryId: categoryId,
            id: id,
            assetUrls: assetUrls,
            name: name,
            price: price,
            classification: classification,
            quantifier: quantifier,
            discountPercentage: discountPercentage);
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
  int reputationPositive;
  int reputationNegative;
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
      this.uType,
      this.reputationPositive,
      this.reputationNegative});
}

class Review {
  int id;
  int productId;
  int rating;
  String desc;
  int userId;
  DateTime date;
  Review(
      {this.id,
      this.productId,
      this.rating,
      this.desc,
      this.userId,
      this.date});
}

class CartProduct {
  List<String> photoUrl;
  String name;
  double price;
  int cartQuantity, id, vendorId;
  Classification classification;
  int quantifier;

  CartProduct(
      {this.id,
      this.vendorId,
      this.photoUrl,
      this.name,
      this.price,
      this.cartQuantity,
      this.classification,
      this.quantifier});
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
  double price;
  DateTime deliveryDate;
  Order(
      {this.id,
      this.productId,
      this.amount,
      this.status,
      this.buyerId,
      this.date,
      this.sellerId,
      this.deliveryAddress,
      this.paymentType,
      this.price,
      this.deliveryDate});
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
    this.unread,
  });

  @override
  String toString() {
    return '[${this.id},${this.chatId},${this.fromId},${this.messageText},${this.timestamp},${this.unread}]';
  }

  int id;
  int chatId;
  int fromId;
  String messageText;
  DateTime timestamp;
  bool unread;

  factory ChatMessageInfo.fromJson(Map<String, dynamic> json) =>
      ChatMessageInfo(
        id: json["id"],
        chatId: json["chatId"],
        fromId: json["fromId"],
        messageText: json["messageText"],
        timestamp: DateTime.parse(json["timestamp"]),
        unread: json["unread"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "fromId": fromId,
        "messageText": messageText,
        "timestamp": timestamp.toIso8601String(),
        "unread": unread,
      };
}
