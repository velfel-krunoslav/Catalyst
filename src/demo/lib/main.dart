import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:io';
import 'dart:convert';
import 'package:eth/config.dart';

void main() {
  runApp(MyApp());
}

class Credentials {
  String publicKey;
  String privateKey;

  Credentials({this.publicKey, this.privateKey});

  Map toJson() => {'publicKey': publicKey, 'privateKey': privateKey};

  factory Credentials.fromJson(dynamic json) {
    return Credentials(
        publicKey: json['publicKey'] as String,
        privateKey: json['privateKey'] as String);
  }
}

class Status extends StatefulWidget {
  Status({Key key, this.publicKey, this.privateKey}) : super(key: key);
  String privateKey;
  String publicKey;

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Client httpClient;
  Web3Client ethClient;
  BigInt value;
  BigInt newValue;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(endpointAddress, httpClient);
    getValue(widget.publicKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        children: [
          Text(
            'Trenutno stanje:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
              height: 60,
              width: 180,
              child: TextField(
                  onChanged: (value) {
                    newValue = BigInt.from(int.tryParse(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Nova vrednost',
                  ))),
          TextButton(
            onPressed: () {
              writeValue();
            },
            child: Text(
              'Upiši',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              getValue(widget.publicKey);
            },
            child: Text(
              'Osveži',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    )));
  }

  // ETH

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');

    final contract = DeployedContract(ContractAbi.fromJson(abi, "PKCoin"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<void> getValue(String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query('getValue', []);

    value = result[0];

    setState(() {});
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> writeValue() async {
    var bigAmount = newValue;
    var response = await submit("writeValue", [bigAmount]);
    print('Deposited.');
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(widget.privateKey);
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);
    return result;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MetaMask Authentication Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String publicKey, privateKey;
  @override
  void initState() {
    super.initState();
    publicKey = '';
    privateKey = '';

    rootBundle
        .loadString('assets/login.json', cache: false)
        .then((String contents) {
      Credentials tmp = Credentials.fromJson(jsonDecode(contents));
      print('auth.json contents: $tmp');
      publicKey = tmp.publicKey;
      privateKey = tmp.privateKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 360,
            height: 60,
            child: TextField(
              onChanged: (value) {
                publicKey = value;
              },
              decoration: InputDecoration(hintText: 'Javni ključ'),
            ),
          ),
          SizedBox(
            width: 360,
            height: 60,
            child: TextField(
              onChanged: (value) {
                privateKey = value;
              },
              decoration: InputDecoration(hintText: 'Privatni ključ'),
            ),
          ),
          TextButton(
              onPressed: () {
                Credentials tmp =
                    Credentials(publicKey: publicKey, privateKey: privateKey);
                String cred = jsonEncode(tmp);
                //File('assets/login.json').writeAsString(cred);
                // TODO
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Status(
                              privateKey: privateKey,
                              publicKey: publicKey,
                            )));
              },
              child: Text(
                'Prijava',
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
    )));
  }
}
