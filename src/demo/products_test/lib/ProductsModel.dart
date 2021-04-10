import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';



class ProductsModel extends ChangeNotifier{
  List<Product> products = [];
  final String _rpcUrl = "HTTP://192.168.0.198:7545";
  final String _wsUrl = "ws://192.168.0.198:7545/";

  final String _privateKey = "f06e9068ea4283c76875eb96eb6bd4da6cd4fc028309b7be61fe02e4bf5d7b1d";

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
    print(_contractAddress);
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

    print(await _client.call(contract: _contract, function: _productsCount, params: []));


  }


}

class Product{
  String name;
  double price;
  Product({this.name,this.price});
}