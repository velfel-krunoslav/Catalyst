import 'dart:collection';
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

class OrdersModel extends ChangeNotifier {
  int buyerId = 0;
  List<Order> orders = [];
  List<DateOrder> dateOrders = [];

  final String _rpcUrl = "HTTP://" + HOST;
  final String _wsUrl = "ws://" + HOST;

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
  ContractFunction _checkForOrder;
  OrdersModel([int b = 0]) {
    this.buyerId = b;
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
    String abiStringFile = await rootBundle.loadString("src/abis/Orders.json");
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
        ContractAbi.fromJson(_abiCode, "Orders"), _contractAddress);

    _ordersCount = _contract.function("ordersCount");
    _orders = _contract.function("orders");
    _createOrder = _contract.function("createOrder");
    _getOrders = _contract.function("getOrders");
    _getOrdersCount = _contract.function("getOrdersCount");
    _checkForOrder = _contract.function("checkForOrder");
    await getOrders(buyerId);
    setDateOrders();
  }

  getOrders(int buyerId) async {
    List totalList = await _client.call(
        contract: _contract,
        function: _getOrdersCount,
        params: [BigInt.from(buyerId)]);
    BigInt total = totalList[0];
    ordersCount = total.toInt();
    var temp = await _client.call(
        contract: _contract,
        function: _getOrders,
        params: [BigInt.from(buyerId), total]);

    for (int i = ordersCount - 1; i >= 0; i--) {
      var t = temp[0][i];

      List<String> dateParts = t[3].split("-");
      DateTime date = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2].substring(0, 2)));
      //print(t);
      Order o = Order(
          id: t[0].toInt(),
          productId: t[1].toInt(),
          amount: t[2].toInt(),
          buyerId: t[5].toInt(),
          sellerId: t[6].toInt(),
          status: t[4].toInt(),
          date: date,
          deliveryAddress: t[7],
          paymentType: t[8].toInt());
      orders.add(o);
    }
    notifyListeners();
  }

  addOrder(List<Order> orders) async {
    isLoading = true;

    for (int i = 0; i < orders.length; i++) {
      String dateStr = orders[i].date.toString();
      if (orders[i].productId != null &&
          orders[i].buyerId != null &&
          orders[i].sellerId != null &&
          dateStr != null) {
        await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
                maxGas: 6721925,
                contract: _contract,
                function: _createOrder,
                parameters: [
                  BigInt.from(orders[i].productId),
                  BigInt.from(orders[i].amount),
                  dateStr,
                  BigInt.from(orders[i].buyerId),
                  BigInt.from(orders[i].sellerId),
                  orders[i].deliveryAddress,
                  BigInt.from(orders[i].paymentType)
                ],
                gasPrice: EtherAmount.inWei(BigInt.one)));
        print("order dodat");

        //getOrders(buyerId);
      } else {
        isLoading = false;
      }
    }}


    setDateOrders() {
      for (int i = 0; i < orders.length; i++) {
        DateTime d = orders[i].date;
        int flag = 0;
        for (int j = 0; j < dateOrders.length; j++) {
          if (dateOrders[j].date.toString() == d.toString()) {
            dateOrders[j].orders.add(orders[i]);
            flag = 1;
          }
        }
        if (flag == 0) {
          dateOrders.add(new DateOrder(date: d, orders: [orders[i]]));
        }
      }
      isLoading = false;
      notifyListeners();
    }

    checkForOrder(int userId, int productId) async {
      var temp = await _client.call(
          contract: _contract,
          function: _checkForOrder,
          params: [BigInt.from(userId), BigInt.from(productId)]);
      return temp[0];
    }
  }

class DateOrder {
  DateTime date;
  List<Order> orders;
  DateOrder({this.date, this.orders});
}
