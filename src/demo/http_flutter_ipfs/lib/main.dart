import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Flutter IPFS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter IPFS'),
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
  getHttpUrl() async {
    var url = Uri.parse(
        'http://127.0.0.1:5001/ipfs/bafybeif4zkmu7qdhkpf3pnhwxipylqleof7rl6ojbe7mq3fzogz6m4xk3i/#/files');
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    await http.get(url, headers: header).then((response) {
      print(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getHttpUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Image.network(
          'http://localhost:8080/ipfs/QmbTgWgyrT7LK7ZAvhKovaohuxDn1YbnL26oKoZgBr5rtc?filename=meme.gif',
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}
