import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../internals.dart';



class ReviewsModel extends ChangeNotifier{
  int productId;
  List<Review> reviews = [];
  List<Review> reviewsForProduct = [];
  double average = 0;
  List<int> starsCount = [0,0,0,0,0];

  final String _rpcUrl = "HTTP://192.168.0.198:7545";
  final String _wsUrl = "ws://192.168.0.198:7545/";

  final String _privateKey = "4ae9cd8ba39afc4693bea1aa5970b1dec9cd042231b8c45ea3d66208618240d6";
  int reviewsCount = 0;
  int reviewsForProductCount = 0;

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
  ContractFunction _reviewsForProduct;
  ContractFunction _getSum;
  ContractFunction _getReviews;
  ContractFunction _countStars;
  ContractFunction _reviewsForProductCount;



  ReviewsModel(int productId){
    this.productId = productId;
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: (){
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
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

  }

  Future<void> getCredentials() async{
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async{
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Reviews"), _contractAddress);

    _reviewsCount = _contract.function("reviewsCount");
    _reviews = _contract.function("reviews");
    _createReview = _contract.function("createReview");
    _getSum = _contract.function("getSum");
    _reviewsForProduct = _contract.function("reviewsForProduct");
    _getReviews = _contract.function("getReviews");
    _countStars = _contract.function("countStars");
    _reviewsForProductCount = _contract.function("reviewsForProductCount");

    getReviewsForProduct(productId);
    //getAverage();
  }

  getReviews() async{
    List totalReviewsList = await _client.call(contract: _contract, function: _reviewsCount, params: []);
    BigInt totalReviews = totalReviewsList[0];
    reviewsCount = totalReviews.toInt();
    reviews.clear();

    for(int i=0; i < totalReviews.toInt(); i++){
      var temp = await _client.call(contract: _contract, function: _reviews, params: [BigInt.from(i)]);

      print(temp);

      reviews.add(Review(id: temp[0].toInt(),
                        productId: temp[1].toInt(),
                        rating: temp[2].toInt(),
                        desc: temp[3],
                        userId: temp[4].toInt()
      ));
    }

    isLoading = false;
    notifyListeners();
  }
  addReview(int productId, int rating, String desc, int userId) async{
    isLoading = true;
    notifyListeners();


    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721925,
            contract: _contract,
            function: _createReview,
            parameters: [BigInt.from(productId), BigInt.from(rating), desc, BigInt.from(userId)],
            gasPrice: EtherAmount.inWei(BigInt.one)));
    getReviews();
  }


  getReviewsForProduct(int productId) async {
    List<Review> rew = [];

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721925,
            contract: _contract,
            function: _getReviews,
            parameters: [BigInt.from(productId)],
            gasPrice: EtherAmount.inWei(BigInt.one)));

    List totalReviewsList = await _client.call(
        contract: _contract, function: _reviewsForProductCount, params: []);
    BigInt totalReviews = totalReviewsList[0];
    reviewsForProductCount = totalReviews.toInt();
    //print("productId "+ productId.toString());
    //print("count " + reviewsForProductCount.toString());
    for (int i = 0; i < totalReviews.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _reviewsForProduct, params: [BigInt.from(i)]);

      print(temp);

      reviewsForProduct.add(Review(id: temp[0].toInt(),
          userId: temp[4].toInt(),
          desc: temp[3],
          productId: temp[1].toInt(),
          rating: temp[2].toInt()));


    }
    getAverage();
    getStars();
    isLoading = false;
    notifyListeners();
  }

  getAverage() async{
    List sumList = await _client.call(
        contract: _contract, function: _getSum, params: []);
    BigInt sumTemp = sumList[0];
    int sum = sumTemp.toInt();
    //print("sum "+sum.toString());
    if (reviewsForProductCount > 0)
      average = sum/reviewsForProductCount;
    notifyListeners();
  }

  getStars(){
    for(int i = 0; i < reviewsForProductCount; i++){
      starsCount[reviewsForProduct[i].rating - 1]++;
    }
  }
}