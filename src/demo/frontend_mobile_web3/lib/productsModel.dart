import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'internals.dart';



class ProductsModel extends ChangeNotifier{
  List<Product> products = [];
  final String _rpcUrl = "HTTP://192.168.0.198:7545";
  final String _wsUrl = "ws://192.168.0.198:7545/";

  final String _privateKey = "a0e8a742d8d57aa6704d59d79cf1ef8f7f43f9d365b555b8e1adc22f789ee30f";
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


  ProductsModel(){
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
    String abiStringFile = await rootBundle.loadString("src/abis/Products.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    //print(_contractAddress);
  }

  Future<void> getCredentials() async{
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async{
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Products"), _contractAddress);

    _productsCount = _contract.function("productsCount");
    _createProduct = _contract.function("createProduct");
    _products = _contract.function("products");
    _productCreatedEvent = _contract.event("ProductCreated");

    getProducts();
  }

  getProducts() async{
    List totalProductsList = await _client.call(contract: _contract, function: _productsCount, params: []);
    BigInt totalProducts = totalProductsList[0];
    productsCount = totalProducts.toInt();
    products.clear();

    for(int i=0; i < totalProducts.toInt(); i++){
      var temp = await _client.call(contract: _contract, function: _products, params: [BigInt.from(i)]);

      print(temp);

      String assets = temp[2];
      var list = temp[2].split(",").toList();

      Classification classif;
      if (temp[3] == 0){
        classif = Classification.Single;
      }
      else if (temp[3] == 1){
        classif = Classification.Weight;
      }
      else{
        classif = Classification.Volume;
      }
      products.add(Product(name: temp[0], price: temp[1], assetUrls: list, classification: classif, quantifier: temp[4]));
    }

    isLoading = false;
    notifyListeners();
  }

  addProduct(String name) async{
    isLoading = true;
    notifyListeners();


    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721925,
            contract: _contract,
            function: _createProduct,
            parameters: [name, BigInt.from(144), "slika.png", BigInt.from(0),BigInt.from(1444)],
            gasPrice: EtherAmount.inWei(BigInt.one)));
    getProducts();
  }


}
//enum Classification { Single, Weight, Volume }
class Product{
  String name;
  BigInt price;
  var assetUrls;
  Classification classification;
  BigInt quantifier;

  Product({this.name,this.price, this.assetUrls,this.classification,this.quantifier});
}