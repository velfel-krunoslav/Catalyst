import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../config.dart';
import '../internals.dart';

class ProductsModel extends ChangeNotifier {
  List<ProductEntry> products = [];
  List<ProductEntry> productsForCategory = [];
  int category = -1;

  final String _rpcUrl = "HTTP://" + HOST;
  final String _wsUrl = "ws://" + HOST;

  final String _privateKey = PRIVATE_KEY;
  int productsCount = 0;

  bool isLoading = true;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;

  ContractFunction _productsCount;
  ContractFunction _products;
  ContractFunction _createProduct;
  ContractEvent _productCreatedEvent;
  ContractFunction _getProductsForCategoryCount;
  ContractFunction _getProductsForCategory;
  ContractFunction _getProductById;
  ContractFunction _getSellerProductsCount;
  ContractFunction _getSellerProducts;

  ProductsModel([int c = -1]) {
    this.category = c;
    initiateSetup();
  }
  //ProductsModel(int c){this.category = c;}
  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/Products.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
        jsonAbi["networks"]["1618970070724"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Products"), _contractAddress);

    _productsCount = _contract.function("productsCount");
    _createProduct = _contract.function("createProduct");
    _products = _contract.function("products");
    _productCreatedEvent = _contract.event("ProductCreated");
    _getProductsForCategoryCount =
        _contract.function("getProductsForCategoryCount");
    _getProductsForCategory = _contract.function("getProductsForCategory");
    _getProductById = _contract.function("getProductById");
    _getSellerProductsCount = _contract.function("getSellerProductsCount");
    _getSellerProducts = _contract.function("getSellerProducts");

    getProducts();
    getProductsForCategory(category);
  }

  getProducts() async {
    List totalProductsList = await _client
        .call(contract: _contract, function: _productsCount, params: []);
    BigInt totalProducts = totalProductsList[0];
    productsCount = totalProducts.toInt();
    products.clear();

    for (int i = productsCount - 1; i >= 0; i--) {
      var temp = await _client.call(
          contract: _contract, function: _products, params: [BigInt.from(i)]);

      //print(temp);
      double price = temp[2].toInt() / temp[3].toInt();
      String assets = temp[4];
      var list = temp[4].split(",").toList();

      Classification classif = getClassification(temp[5].toInt());

      products.add(ProductEntry(
          id: temp[0].toInt(),
          name: temp[1],
          price: price,
          assetUrls: list,
          classification: classif,
          quantifier: temp[6].toInt(),
          desc: temp[7],
          sellerId: temp[8].toInt()));
    }

    isLoading = false;
    notifyListeners();
  }

  getClassification(int num) {
    if (num == 0) {
      return Classification.Single;
    } else if (num == 1) {
      return Classification.Weight;
    } else {
      return Classification.Volume;
    }
  }

  addProduct(
      String name,
      double price,
      List<String> assetUrls,
      int classification,
      int quantifier,
      String desc,
      int sellerId,
      int categoryId) async {
    isLoading = true;
    price = double.parse(price.toStringAsFixed(2));
    Fraction frac1 = price.toFraction();
    int numinator = frac1.numerator;
    int denuminator = frac1.denominator;
    String assets = "";
    for (int i = 0; i < assetUrls.length; i++) {
      assets += assetUrls[i];
      if (i != assetUrls.length - 1) assets += ",";
    }
    if (name != null &&
        price != null &&
        assets != "" &&
        classification != null &&
        desc != null &&
        sellerId != null &&
        categoryId != null) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721925,
              contract: _contract,
              function: _createProduct,
              parameters: [
                name,
                BigInt.from(numinator),
                BigInt.from(denuminator),
                assets,
                BigInt.from(classification),
                BigInt.from(quantifier),
                desc,
                BigInt.from(sellerId),
                BigInt.from(categoryId)
              ],
              gasPrice: EtherAmount.inWei(BigInt.one)));
      print("proizvod dodat");
      getProducts();
    } else {
      isLoading = false;
    }
  }

  getProductsForCategory(int c) async {
    if (c != -1) {
      List totalProductsList = await _client.call(
          contract: _contract,
          function: _getProductsForCategoryCount,
          params: [BigInt.from(c)]);
      BigInt totalProducts = totalProductsList[0];
      productsCount = totalProducts.toInt();
      var temp = await _client.call(
          contract: _contract,
          function: _getProductsForCategory,
          params: [BigInt.from(c), totalProducts]);
      for (int i = productsCount - 1; i >= 0; i--) {
        var t = temp[0][i];
        //print(t);
        productsForCategory.add(ProductEntry(
            id: t[0].toInt(),
            name: t[1],
            price: t[2].toInt() / t[3].toInt(),
            assetUrls: t[4].split(",").toList(),
            classification: getClassification(t[5].toInt()),
            quantifier: t[6].toInt(),
            desc: t[7],
            sellerId: t[8].toInt()));
      }
      isLoading = false;
      notifyListeners();
    }
  }

  getProductById(int id) async {
    isLoading = true;
    var temp = await _client.call(
        contract: _contract,
        function: _getProductById,
        params: [BigInt.from(id)]);
    temp = temp[0];
    ProductEntry product = ProductEntry(
        id: temp[0].toInt(),
        name: temp[1],
        price: temp[2].toInt() / temp[3].toInt(),
        assetUrls: temp[4].split(",").toList(),
        classification: getClassification(temp[5].toInt()),
        quantifier: temp[6].toInt(),
        desc: temp[7],
        sellerId: temp[8].toInt());
    isLoading = false;
    return product;
  }

  getSellersProducts(int sellerId) async {
    List<ProductEntry> sellersProducts = [];
    List totalProductsList = await _client.call(
        contract: _contract,
        function: _getSellerProductsCount,
        params: [BigInt.from(sellerId)]);
    BigInt totalProducts = totalProductsList[0];
    productsCount = totalProducts.toInt();
    var temp = await _client.call(
        contract: _contract,
        function: _getSellerProducts,
        params: [BigInt.from(sellerId), totalProducts]);
    for (int i = productsCount - 1; i >= 0; i--) {
      var t = temp[0][i];
      //print(t);
      sellersProducts.add(ProductEntry(
          id: t[0].toInt(),
          name: t[1],
          price: t[2].toInt() / t[3].toInt(),
          assetUrls: t[4].split(",").toList(),
          classification: getClassification(t[5].toInt()),
          quantifier: t[6].toInt(),
          desc: t[7],
          sellerId: t[8].toInt()));
    }
    // isLoading = false;
    // notifyListeners();
    return sellersProducts;
  }
}
