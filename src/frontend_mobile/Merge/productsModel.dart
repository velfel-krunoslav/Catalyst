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
  List<ProductEntry> discountedProducts = [];
  List<ProductEntry> productsForCategory = [];
  int category = -1;
  int userId;
  String query;
  List<ProductEntry> productsOrg;
  List<ProductEntry> discountedProductsOrg;

  String _minPrice;
  String _maxPrice;
  String _sort;
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
  ContractFunction _getQueryProducts;
  ContractFunction _getQueryProductsCount;
  ContractFunction _setSale;
  ContractFunction _removeProduct;
  ContractFunction _editProduct;

  ProductsModel([int c = -1]) {
    this.category = c;
    initiateSetup();
  }
  ProductsModel.forVendor(int id) {
    this.userId = id;
    initiateSetup();
  }
  int productId;
  ProductEntry product;
  ProductsModel.forId(int id) {
    this.productId = id;
    initiateSetup();
  }
  List<ProductEntry> productsToDisplay = [];
  int productsToDisplayCount;
  ProductsModel.fromQuery(String query) {
    this.query = query;
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
    String abiStringFile =
        await rootBundle.loadString("src/abis/Products.json");
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
    _getQueryProducts = _contract.function("getQueryProducts");
    _getQueryProductsCount = _contract.function("getQueryProductsCount");
    _setSale = _contract.function("setSale");
    _removeProduct = _contract.function("removeProduct");
    _editProduct = _contract.function("editProduct");

    if (productId != null) {
      product = await getProductById(productId);
      isLoading = false;
      notifyListeners();
    } else if (userId != null)
      products = await getSellersProducts(userId);
    else if (query != null) {
      getQueryProducts(query);
    } else {
      getProducts();
      getProductsForCategory(category);
    }
  }

  editProduct(
      int _id,
      String _productName,
      double _price,
      List<String> _assetUrls,
      int _classif,
      int _quantifier,
      String _desc,
      int _categoryId,
      int _inStock) async {
    isLoading = true;
    _price = double.parse(_price.toStringAsFixed(2));
    Fraction frac1 = _price.toFraction();
    int numinator = frac1.numerator;
    int denuminator = frac1.denominator;
    String assets = "";
    for (int i = 0; i < _assetUrls.length; i++) {
      assets += _assetUrls[i];
      if (i != _assetUrls.length - 1) assets += ",";
    }
    if (_productName != null &&
        _price != null &&
        assets != "" &&
        _classif != null &&
        _desc != null &&
        _categoryId != null) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721925,
              contract: _contract,
              function: _editProduct,
              parameters: [
                BigInt.from(_id),
                _productName,
                BigInt.from(numinator),
                BigInt.from(denuminator),
                assets,
                BigInt.from(_classif),
                BigInt.from(_quantifier),
                _desc,
                BigInt.from(_categoryId),
                BigInt.from(_inStock),
              ],
              gasPrice: EtherAmount.inWei(BigInt.one)));

      if (userId != null)
        products = await getSellersProducts(userId);
      else
        getProducts();
    } else {
      isLoading = false;
    }
  }

  getQueryProducts(String query) async {
    isLoading = true;
    notifyListeners();
    List<ProductEntry> queryProducts = [];
    List<ProductEntry> disQueryProducts = [];
    List totalProductsList = await _client.call(
        contract: _contract, function: _getQueryProductsCount, params: [query]);
    BigInt totalProducts = totalProductsList[0];
    int queryProductsCount = totalProducts.toInt();
    var temp = await _client.call(
        contract: _contract,
        function: _getQueryProducts,
        params: [query, totalProducts]);
    for (int i = queryProductsCount - 1; i >= 0; i--) {
      var t = temp[0][i];

      if (t[4].toInt() == 0) {
        queryProducts.add(ProductEntry(
            id: t[0].toInt(),
            name: t[1],
            price: t[2].toInt() / t[3].toInt(),
            assetUrls: t[5].split(",").toList(),
            classification: getClassification(t[6].toInt()),
            quantifier: t[7].toInt(),
            desc: t[8],
            discountPercentage: t[4].toInt(),
            categoryId: t[10].toInt(),
            sellerId: t[9].toInt(),
            inStock: t[11].toInt()));
      } else {
        disQueryProducts.add(ProductEntry(
            id: t[0].toInt(),
            name: t[1],
            price: t[2].toInt() / t[3].toInt(),
            assetUrls: t[5].split(",").toList(),
            classification: getClassification(t[6].toInt()),
            quantifier: t[7].toInt(),
            desc: t[8],
            discountPercentage: t[4].toInt(),
            categoryId: t[10].toInt(),
            sellerId: t[9].toInt(),
            inStock: t[11].toInt()));
      }
    }
    productsCount = queryProductsCount;
    products = queryProducts;
    discountedProducts = disQueryProducts;
    productsOrg = products;
    discountedProductsOrg = discountedProducts;
    apply(_minPrice, _maxPrice, _sort);
    isLoading = false;
    notifyListeners();
  }

  getProducts() async {
    List totalProductsList = await _client
        .call(contract: _contract, function: _productsCount, params: []);
    BigInt totalProducts = totalProductsList[0];
    productsCount = totalProducts.toInt();
    products.clear();
    discountedProducts.clear();
    for (int i = productsCount - 1; i >= 0; i--) {
      var temp = await _client.call(
          contract: _contract, function: _products, params: [BigInt.from(i)]);

      //print(temp);
      double price = temp[2].toInt() / temp[3].toInt();
      String assets = temp[5];
      var list = temp[5].split(",").toList();

      Classification classif = getClassification(temp[6].toInt());
      if (temp[4].toInt() == 0) {
        products.add(ProductEntry(
            id: temp[0].toInt(),
            name: temp[1],
            price: price,
            discountPercentage: temp[4].toInt(),
            assetUrls: list,
            classification: classif,
            quantifier: temp[7].toInt(),
            desc: temp[8],
            sellerId: temp[9].toInt(),
            categoryId: temp[10].toInt(),
            inStock: temp[11].toInt()));
      } else {
        discountedProducts.add(ProductEntry(
            id: temp[0].toInt(),
            name: temp[1],
            price: price,
            discountPercentage: temp[4].toInt(),
            assetUrls: list,
            classification: classif,
            quantifier: temp[7].toInt(),
            desc: temp[8],
            sellerId: temp[9].toInt(),
            categoryId: temp[10].toInt(),
            inStock: temp[11].toInt()));
      }
    }
    productsOrg = products;
    discountedProductsOrg = discountedProducts;
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
      int categoryId,
      int inStock) async {
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
                BigInt.from(0),
                assets,
                BigInt.from(classification),
                BigInt.from(quantifier),
                desc,
                BigInt.from(sellerId),
                BigInt.from(categoryId),
                BigInt.from(inStock)
              ],
              gasPrice: EtherAmount.inWei(BigInt.one)));
      print("proizvod dodat");

      if (userId != null)
        products = await getSellersProducts(userId);
      else
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
        productsForCategory.add(ProductEntry(
            id: t[0].toInt(),
            name: t[1],
            price: t[2].toInt() / t[3].toInt(),
            discountPercentage: t[4].toInt(),
            assetUrls: t[5].split(",").toList(),
            classification: getClassification(t[6].toInt()),
            quantifier: t[7].toInt(),
            desc: t[8],
            sellerId: t[9].toInt(),
            inStock: t[11].toInt()));
      }
      isLoading = false;
      notifyListeners();
    }
  }

  getProductById(int id) async {
    var temp = await _client.call(
        contract: _contract,
        function: _getProductById,
        params: [BigInt.from(id)]);
    temp = temp[0];
    ProductEntry product = ProductEntry(
        id: temp[0].toInt(),
        name: temp[1],
        price: temp[2].toInt() / temp[3].toInt(),
        discountPercentage: temp[4].toInt(),
        assetUrls: temp[5].split(",").toList(),
        classification: getClassification(temp[6].toInt()),
        quantifier: temp[7].toInt(),
        desc: temp[8],
        sellerId: temp[9].toInt(),
        inStock: temp[11].toInt());

    return product;
  }

  getSellersProducts(int sellerId) async {
    isLoading = true;
    notifyListeners();
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
          discountPercentage: t[4].toInt(),
          assetUrls: t[5].split(",").toList(),
          classification: getClassification(t[6].toInt()),
          quantifier: t[7].toInt(),
          desc: t[8],
          sellerId: t[9].toInt(),
          categoryId: t[10].toInt(),
          inStock: t[11].toInt()));
    }
    isLoading = false;
    notifyListeners();
    return sellersProducts;
  }

  setSale(int productId, int discountPercentage) async {
    isLoading = true;
    notifyListeners();
    if (productId != null && discountPercentage != null) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721925,
              contract: _contract,
              function: _setSale,
              parameters: [
                BigInt.from(productId),
                BigInt.from(discountPercentage)
              ],
              gasPrice: EtherAmount.inWei(BigInt.one)));
      products = await getSellersProducts(userId);
      isLoading = false;
      notifyListeners();
    }
  }

  removeProduct(int productId) async {
    isLoading = true;
    notifyListeners();
    if (productId != null) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721925,
              contract: _contract,
              function: _removeProduct,
              parameters: [
                BigInt.from(productId),
              ],
              gasPrice: EtherAmount.inWei(BigInt.one)));
      products = await getSellersProducts(userId);
      isLoading = false;
      notifyListeners();
    }
  }

  apply(String minPrice, String maxPrice, String filterCategoryName) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _sort = filterCategoryName;
    isLoading = true;
    notifyListeners();

    if (minPrice == "" ||
        minPrice == null ||
        !_isNumeric(minPrice) ||
        minPrice.isEmpty) {
      minPrice = getMinPrice(productsOrg, discountedProductsOrg);
    }
    if (maxPrice == "" ||
        maxPrice == null ||
        !_isNumeric(maxPrice) ||
        maxPrice.isEmpty) {
      maxPrice = getMaxPrice(productsOrg, discountedProductsOrg);
    }
    products = productsOrg
        .where((p) =>
            p.price >= double.parse(minPrice) &&
            p.price <= double.parse(maxPrice))
        .toList();
    discountedProducts = discountedProductsOrg
        .where((e) =>
            (e.price - (e.price * e.discountPercentage / 100)) >=
                double.parse(minPrice) &&
            (e.price - (e.price * e.discountPercentage / 100)) <=
                double.parse(maxPrice))
        .toList();
    if (filterCategoryName == "Najjeftinije prvo") {
      products.sort((a, b) => a.price.compareTo(b.price));
      discountedProducts.sort((a, b) =>
          (a.price - (a.price * a.discountPercentage / 100))
              .compareTo((b.price - (b.price * b.discountPercentage / 100))));
    } else if (filterCategoryName == "Najskuplje prvo") {
      products.sort((a, b) => b.price.compareTo(a.price));
      discountedProducts.sort((a, b) =>
          (b.price - (b.price * b.discountPercentage / 100))
              .compareTo((a.price - (a.price * a.discountPercentage / 100))));
    } else {
      products.sort((a, b) => a.id.compareTo(b.id));
      discountedProducts.sort((a, b) => a.id.compareTo(b.id));
    }

    isLoading = false;
    notifyListeners();
  }

  bool _isNumeric(String str) {
    try {
      var value = double.parse(str);
    } on FormatException {
      return false;
    } finally {
      return true;
    }
  }

  String getMinPrice(List<ProductEntry> list, List<ProductEntry> disc) {
    ProductEntry min;
    if (list.isNotEmpty) {
      min = list[0];
      list.forEach((e) {
        if (e.price < min.price) min = e;
      });
    }
    list.isEmpty && disc.isNotEmpty ? min = disc[0] : min = min;
    if (disc.isNotEmpty) {
      disc.forEach((e) {
        if ((e.price - (e.price * e.discountPercentage / 100)) <
            (min.price - (min.price * min.discountPercentage / 100))) min = e;
      });
    }
    if (min != null) {
      if (min.discountPercentage != 0)
        return (min.price - (min.price * min.discountPercentage / 100))
            .toString();

      return min.price.toString();
    } else
      return "0";
  }

  String getMaxPrice(List<ProductEntry> list, List<ProductEntry> disc) {
    ProductEntry max = null;
    if (list.isNotEmpty) {
      max = list.first;
      list.forEach((e) {
        if (e.price > max.price) max = e;
      });
    }
    list.isEmpty && disc.isNotEmpty ? max = disc[0] : max = max;
    if (disc.isNotEmpty) {
      disc.forEach((e) {
        if ((e.price - (e.price * e.discountPercentage / 100)) >
            (max.price - (max.price * max.discountPercentage / 100))) max = e;
      });
    }
    if (max != null) {
      if (max.discountPercentage != 0)
        return (max.price - (max.price * max.discountPercentage / 100))
            .toString();

      return max.price.toString();
    } else {
      return "0";
    }
  }
}
