import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../config.dart';
import '../internals.dart';

class ReviewsModel extends ChangeNotifier {
  int productId;
  List<Review> reviews = [];
  double average = 0;
  List<int> starsCount = [0, 0, 0, 0, 0];

  final String _rpcUrl = "HTTP://" + HOST;
  final String _wsUrl = "ws://" + HOST;
  final String _privateKey = PRIVATE_KEY;
  int reviewsCount = 0;

  bool isLoading = true;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;

  ContractFunction _reviewsCount;
  ContractFunction _reviews;
  ContractFunction _createReview;
  ContractFunction _getSum;
  ContractFunction _getReviews;
  ContractFunction _countStars;
  ContractFunction _getReviewsCount;

  ReviewsModel(int productId) {
    this.productId = productId;
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle.loadString("src/abis/Reviews.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
        jsonAbi["networks"][JSON_NETWORK_ATTR]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Reviews"), _contractAddress);

    _reviewsCount = _contract.function("reviewsCount");
    _reviews = _contract.function("reviews");
    _createReview = _contract.function("createReview");
    _getSum = _contract.function("getSum");
    _getReviews = _contract.function("getReviews");
    _countStars = _contract.function("countStars");
    _getReviewsCount = _contract.function("getReviewsCount");

    await getReviews(productId);
    await getAverage();
    await getStars();
  }

  getReviews(int productId) async {
    List totalReviewsList = await _client.call(
        contract: _contract,
        function: _getReviewsCount,
        params: [BigInt.from(productId)]);
    BigInt totalReviews = totalReviewsList[0];
    reviewsCount = totalReviews.toInt();

    var temp = await _client.call(
        contract: _contract,
        function: _getReviews,
        params: [BigInt.from(productId), totalReviews]);

    for (int i = 0; i < reviewsCount; i++) {
      var t = temp[0][i];
      //print(t);
      reviews.add(Review(
          id: t[0].toInt(),
          userId: t[4].toInt(),
          desc: t[3],
          productId: t[1].toInt(),
          rating: t[2].toInt()));
    }

    notifyListeners();
  }

  addReview(int productId, int rating, String desc, int userId) async {
    isLoading = true;
    notifyListeners();

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721925,
            contract: _contract,
            function: _createReview,
            parameters: [
              BigInt.from(productId),
              BigInt.from(rating),
              desc,
              BigInt.from(userId)
            ],
            gasPrice: EtherAmount.inWei(BigInt.one)));
    getReviews(productId);
  }

  getAverage() async {
    List sumList = await _client.call(
        contract: _contract,
        function: _getSum,
        params: [BigInt.from(productId)]);
    BigInt sumTemp = sumList[0];
    int sum = sumTemp.toInt();
    if (reviewsCount > 0) average = sum / reviewsCount;
    notifyListeners();
  }

  getStars() async {
    for (int i = 0; i < 5; i++) {
      List starC = await _client.call(
          contract: _contract,
          function: _countStars,
          params: [BigInt.from(productId), BigInt.from(i + 1)]);
      BigInt temp = starC[0];
      int starCount = temp.toInt();
      starsCount[i] = starCount;
    }
    isLoading = false;
    notifyListeners();
  }
}
