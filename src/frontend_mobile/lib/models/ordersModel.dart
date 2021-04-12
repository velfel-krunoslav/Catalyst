import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../config.dart';
import '../internals.dart';



class OrdersModel extends ChangeNotifier{
  int buyerId = 0;
  List<Order> orders = [];

  final String _rpcUrl = "HTTP://"+HOST;
  final String _wsUrl = "ws://"+HOST;

  final String _privateKey = PRIVATE_KEY;
  int ordersCount = 0;

  bool isLoading = true;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;

  ContractFunction _ordersCount;
  ContractFunction _orders;
  ContractFunction _createOrder;
  ContractFunction _getOrders;
  ContractFunction _getOrdersCount;

  OrdersModel([int b = 0]){
    this.buyerId = b;
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
    String abiStringFile = await rootBundle.loadString("src/abis/Orders.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

  }

  Future<void> getCredentials() async{
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async{
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Orders"), _contractAddress);

    _ordersCount = _contract.function("ordersCount");
    _orders = _contract.function("orders");
    _createOrder = _contract.function("createOrder");
    _getOrders = _contract.function("getOrders");
    _getOrdersCount = _contract.function("getOrdersCount");
    await getOrders(buyerId);

  }
  getOrders(int buyerId) async {
    List totalList = await _client.call(
        contract: _contract, function: _getOrdersCount, params: [BigInt.from(buyerId)]);
    BigInt total = totalList[0];
    ordersCount = total.toInt();
    var temp = await _client.call(
        contract: _contract,
        function: _getOrders,
        params: [BigInt.from(buyerId), total]);

    for (int i = ordersCount-1; i >= 0; i--) {
  
      var t = temp[0][i];
      var idsTemp = t[1].split(",").toList();
      List<int> ids = [];
      for(int i = 0; i < idsTemp.length; i++){
        ids.add(int.parse(idsTemp[i]));
      }
      double price = t[2].toInt() / t[3].toInt();
      List<String> dateParts = t[4].split("-");
      DateTime date = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2].substring(0,2)));
      //print(t);
      orders.add(Order(
        id: t[0].toInt(),
        productIds: ids,
        buyerId: t[3].toInt(),
        status: t[2].toInt(),
        date: date,
        price: price  

      ));
    }

    notifyListeners();
  }


  addOrder(List<int> _productIds, int _buyerId, double _price, DateTime _date) async{
    isLoading = true;
    notifyListeners();

    _price = double.parse(_price.toStringAsFixed(2));
    Fraction frac1 = _price.toFraction();
    int numinator = frac1.numerator;
    int denuminator = frac1.denominator;
    String ids = "";
    for (int i = 0 ; i < _productIds.length; i++){
      ids += _productIds[i].toString();
      if (i != ids.length - 1)
        ids += ",";
    }
    String dateStr = _date.toString();
    if (ids!=null && _buyerId != null && numinator != null && denuminator != null && dateStr != null){
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721925,
            contract: _contract,
            function: _createOrder,
            parameters: [ids, BigInt.from(_buyerId), BigInt.from(numinator), BigInt.from(denuminator), dateStr],
            gasPrice: EtherAmount.inWei(BigInt.one)));
    print("order dodat");
    getOrders(buyerId);
    }
    else{
      isLoading = false;
    }
  }

}