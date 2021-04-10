import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile/config.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../internals.dart';



class CategoriesModel extends ChangeNotifier{
  List<Category> categories = [];
  final String _rpcUrl = "HTTP://"+HOST;
  final String _wsUrl = "ws://"+HOST;

  final String _privateKey = PRIVATE_KEY;
  int categoriesCount = 0;

  bool isLoading = true;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;

  ContractFunction _categoriesCount;
  ContractFunction _categories;


  CategoriesModel(){
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
    String abiStringFile = await rootBundle.loadString("src/abis/Categories.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

  }

  Future<void> getCredentials() async{
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async{
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Products"), _contractAddress);

    _categoriesCount = _contract.function("categoriesCount");
    _categories = _contract.function("categories");
    getCategories();
  }

  getCategories() async{
    List totalCategoriesList = await _client.call(contract: _contract, function: _categoriesCount, params: []);
    BigInt totalCategories = totalCategoriesList[0];
    categoriesCount = totalCategories.toInt();
    categories.clear();

    for(int i=0; i < totalCategories.toInt(); i++){
      var temp = await _client.call(contract: _contract, function: _categories, params: [BigInt.from(i)]);

      print(temp);

      categories.add(Category(id: temp[0].toInt(),
          name: temp[1],
          assetUrl: temp[2]));
    }

    isLoading = false;
    notifyListeners();
  }



}