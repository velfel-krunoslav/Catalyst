import 'package:animated_button/animated_button.dart';
import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  void login()async{
    debugPrint(user);
    debugPrint(pass);

    var h = Map<String, String>();

    h['content-type'] = 'application/json';
  

    var b = Map<dynamic, dynamic>();
    

    if(user == "" || pass == "") return;

    b['username'] = user;
    b['password'] = pass;

    var json = convert.jsonEncode(b);

    var url = Uri.http("10.0.2.2:61029", "/login");

    var res = await http.post("http://10.0.2.2:61029/login", headers: h, body: json);

    if(res.statusCode==200){
      _showMyDialog("Uspešno logovanje");

    }
    else{
      _showMyDialog("Greška");
    }
  }

  String user = "";
  String pass = "";

  void _showMyDialog(String poruka) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Obavestenje'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(poruka),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login page")
      ),
      body: Container(
        child: Column(
          children: [
            BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                backgroundColor: Colors.purple[100],
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text,
                textColor: Colors.black,
                prefixIcon: Icon(
                  Icons.supervised_user_circle_outlined
                ),
                placeholder: "Username",
                onTap: () {
                  print('Click');
                },
                onChanged: (t) {
                  setState(() {
                    user = t;
                  });
                },
                //suffixIcon: Icon(Icons.remove_red_eye),
              ),
            SizedBox(
              height: 30,
            ),
            BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                backgroundColor: Colors.purple[100],
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text,
                textColor: Colors.black,
                prefixIcon: Icon(
                  Icons.lock_outline
                ),
                placeholder: "Password",
                onChanged: (t) {
                  setState(() {
                    pass = t;
                  });
                },
                onSubmitted: (d) {
                  login();
                },
                //suffixIcon: Icon(Icons.remove_red_eye),
              ),
              SizedBox(
              height: 30,
            ),
            AnimatedButton(
              child: Text(
                'Log in',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              color: Colors.purple[200],
              onPressed: login,
              enabled: true,
              shadowDegree: ShadowDegree.light,
            ),
          ],
          
        ),
        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
      ),
      
    );
  }
}