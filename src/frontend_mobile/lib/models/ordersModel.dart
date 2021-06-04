import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../config.dart';
import '../internals.dart';

class OrdersModel extends ChangeNotifier {
  int userId = 0;
  List<Order> orders = [];
  List<Order> deliveryOrders = [];
  List<DateOrder> dateOrders = [];
  final String _rpcUrl = "HTTP://" + HOST;
  final String _wsUrl = "ws://" + HOST;

  final String _privateKey = PRIVATE_KEY;
  int ordersCount = 0;
  int deliveryOrdersCount = 0;
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
  ContractFunction _getDeliveryOrders;
  ContractFunction _getDeliveryOrdersCount;
  ContractFunction _setStatus;

  OrdersModel([int b = 0]) {
    this.userId = b;
    initiateSetup();
  }
  int productId;
  bool isValid;
  OrdersModel.check(int userId, int productId) {
    this.userId = userId;
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
    _getDeliveryOrders = _contract.function("getDeliveryOrders");
    _getDeliveryOrdersCount = _contract.function("getDeliveryOrdersCount");
    _setStatus = _contract.function("setStatus");

    if (productId != null && userId != null) {
      isValid = await checkForOrder(userId, productId);
      isLoading = false;
      notifyListeners();
    } else {
      await getOrders(userId);
      setDateOrders();
      await getDeliveryOrders(userId);
    }
  }

  setStatus(int orderId, int status) async {
    if (orderId != null && status != null) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721925,
              contract: _contract,
              function: _setStatus,
              parameters: [BigInt.from(orderId), BigInt.from(status)],
              gasPrice: EtherAmount.inWei(BigInt.one)));
      getDeliveryOrders(userId);
    }
  }

  getDeliveryOrders(int userId) async {
    isLoading = true;
    notifyListeners();
    List totalList = await _client.call(
        contract: _contract,
        function: _getDeliveryOrdersCount,
        params: [BigInt.from(userId)]);
    BigInt total = totalList[0];
    deliveryOrdersCount = total.toInt();
    var temp = await _client.call(
        contract: _contract,
        function: _getDeliveryOrders,
        params: [BigInt.from(userId), total]);
    deliveryOrders.clear();
    for (int i = deliveryOrdersCount - 1; i >= 0; i--) {
      var t = temp[0][i];
      if (t[4].toInt() == 0) {
        List<String> dateParts = t[3].split("-");
        DateTime date = DateTime(int.parse(dateParts[0]),
            int.parse(dateParts[1]), int.parse(dateParts[2].substring(0, 2)));
        DateTime deliveryDate;
        if (t[11] != "ODMAH") {
          dateParts = t[11].split("-");
          deliveryDate = DateTime(int.parse(dateParts[0]),
              int.parse(dateParts[1]), int.parse(dateParts[2].substring(0, 2)));
        }
        else
          deliveryDate = null;
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
            paymentType: t[8].toInt(),
            price: t[9].toInt() / t[10].toInt(),
        deliveryDate: deliveryDate);
        deliveryOrders.add(o);
      }
    }
    isLoading = false;
    notifyListeners();
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
      DateTime deliveryDate;
      if (t[11] != "ODMAH") {
        dateParts = t[11].split("-");
        deliveryDate = DateTime(int.parse(dateParts[0]),
            int.parse(dateParts[1]), int.parse(dateParts[2].substring(0, 2)));
      }
      else
        deliveryDate = null;
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
          paymentType: t[8].toInt(),
          price: t[9].toInt() / t[10].toInt(),
      deliveryDate: deliveryDate);
      orders.add(o);
    }
    notifyListeners();
  }

  addOrders(List<Order> orders) async {
    isLoading = true;

    for (int i = 0; i < orders.length; i++) {
      String dateStr = orders[i].date.toString();
      String deliveryDateStr;
      if(orders[i].deliveryDate != null)
        deliveryDateStr = orders[i].deliveryDate.toString();
      else
        deliveryDateStr = "ODMAH";
      if (orders[i].productId != null &&
          orders[i].buyerId != null &&
          orders[i].sellerId != null &&
          dateStr != null) {
        double price = double.parse(orders[i].price.toStringAsFixed(2));
        Fraction frac1 = price.toFraction();
        int numinator = frac1.numerator;
        int denuminator = frac1.denominator;
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
                  BigInt.from(orders[i].paymentType),
                  BigInt.from(numinator),
                  BigInt.from(denuminator),
                  deliveryDateStr
                ],
                gasPrice: EtherAmount.inWei(BigInt.one)));
        print("order dodat");

        //getOrders(buyerId);
      } else {
        isLoading = false;
      }
    }
  }

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
    //isLoading = false;
    //notifyListeners();
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
