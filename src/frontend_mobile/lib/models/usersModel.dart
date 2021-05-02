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

class UsersModel extends ChangeNotifier {


  int usersCount = 0;
  User user;
  int id;
  String privateKey;
  String accountAddress;
  final String _rpcUrl = "HTTP://" + HOST;
  final String _wsUrl = "ws://" + HOST;

  final String _privateKey = PRIVATE_KEY;

  bool isLoading = true;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;

  ContractFunction _usersCount;
  ContractFunction _users;
  ContractFunction _checkForUser;
  ContractFunction _createUser;
  ContractFunction _getUser;
  ContractFunction _getUserById;

  UsersModel([String privateKey = "", String accountAddress = ""]) {
    this.privateKey = privateKey;
    this.accountAddress = accountAddress;
    initiateSetup();
  }
  UsersModel.fromId(int id){
    this.id = id;
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
    String abiStringFile = await rootBundle.loadString("src/abis/Users.json");
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
        ContractAbi.fromJson(_abiCode, "Users"), _contractAddress);

    _usersCount = _contract.function("usersCount");
    _users = _contract.function("users");
    _checkForUser = _contract.function("checkForUser");
    _createUser = _contract.function("createUser");
    _getUser = _contract.function("getUser");
    _getUserById = _contract.function("getUserById");
    if (privateKey!=null && privateKey!="" && accountAddress!=null && accountAddress!=""){
      user = await getUser(privateKey, accountAddress);
    }
    else if (id !=null && id > -1){
      user = await getUserById(id);
    }
    isLoading = false;
  }


  Future<int> checkForUser(String _metamastAddress, String _privateKey) async {

    List totalUsersList = await _client.call(contract: _contract, function: _usersCount, params: []);
    BigInt totalUsers = totalUsersList[0];
    usersCount = totalUsers.toInt();
    List<User> users = [];
    for (int i = usersCount - 1; i >= 0; i--) {
      var temp = await _client.call(
          contract: _contract, function: _users, params: [BigInt.from(i)]);
      users.add(User(
        id: temp[0].toInt(),
        name: temp[1],
        surname: temp[2],
        privateKey: temp[3],
          metamaskAddress : temp[4],
          photoUrl: temp[5],
      desc: temp[6],
      email: temp[7],
      phoneNumber: temp[8],
      homeAddress : temp[9],
      birthday : temp[10],
      uType: temp[11].toInt()
      ));
    }

    int id = -1;

    for (int i = usersCount - 1; i >= 0; i--) {
      if (users[i].metamaskAddress.compareTo(_metamastAddress) == 0 && users[i].privateKey.compareTo(_privateKey) == 0)
        id = users[i].id;
    }


    print("id - " + id.toString());
    return id;
  }
  createUser(String _name,
  String _surname,
  String _privateKey,
  String _metamaskAddress,
  String _photoUrl,
      String _desc,
  String _email,
      String _phoneNumber,
  String _homeAddress,
  String _birthday,
  int _uType) async {
    isLoading = true;

    if (_privateKey != null && _metamaskAddress != null) {      //TODO dodati ostale
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721925,
              contract: _contract,
              function: _createUser,
              parameters: [
                _name,
                _surname,
                _privateKey,
                _metamaskAddress,
                _photoUrl,
                _desc,
                _email,
                _phoneNumber,
                _homeAddress,
                _birthday,
                BigInt.from(_uType)
              ],
              gasPrice: EtherAmount.inWei(BigInt.one)));

      print("user dodat");
      List totalUsersList = await _client.call(contract: _contract, function: _usersCount, params: []);
      BigInt totalUsers = totalUsersList[0];
      usersCount = totalUsers.toInt();
      return usersCount - 1;
    } else {
      isLoading = false;
    }
  }
  Future<User> getUser(String privateKey, String accountAddress) async {
    isLoading = true;
    var temp = await _client.call(
        contract: _contract,
        function: _getUser,
        params: [privateKey, accountAddress]);
    temp = temp[0];
    User user = User(
        id: temp[0].toInt(),
        name: temp[1],
        surname: temp[2],
        privateKey: temp[3],
        metamaskAddress: temp[4],
        photoUrl: temp[5],
        desc: temp[6],
        email:temp[7],
        phoneNumber: temp[8],
        homeAddress: temp[9],
        birthday: temp[10],
        uType: temp[11].toInt()
        );

    isLoading = false;
    return user;
  }

  getUserById(int id) async {
    isLoading = true;
    var temp = await _client.call(
        contract: _contract,
        function: _getUserById,
        params: [BigInt.from(id)]);
    temp = temp[0];
    User userr = User(
        id: temp[0].toInt(),
        name: temp[1],
        surname: temp[2],
        privateKey: temp[3],
        metamaskAddress: temp[4],
        photoUrl: temp[5],
        desc: temp[6],
        email:temp[7],
        phoneNumber: temp[8],
        homeAddress: temp[9],
        birthday: temp[10],
        uType: temp[11].toInt()
    );
    isLoading = false;
    notifyListeners();
    return userr;
  }
}