import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import '../config.dart';
import '../internals.dart';
import '../models/categoriesModel.dart';
import '../models/usersModel.dart';
import '../widgets.dart';
import '../pages/sign_up.dart';
import '../pages/consumer_home.dart';
import 'package:provider/provider.dart';
import '../models/productsModel.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  UsersModel usersModel;
  int userId;
  String privateKey = '';
  String accountAddress = '';
  bool isLoading;

  @override
  void initState() {
    super.initState();
    this.isLoading = false;
  }

  void switchState() {
    setState(() {
      this.isLoading = !(this.isLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback startLoginRoutine = () {
      if (privateKey != null &&
          privateKey != "" &&
          accountAddress != null &&
          accountAddress != "") {
        switchState();
        privateKey = privateKey.trim();
        accountAddress = accountAddress.trim();
        usersModel.checkForUser(accountAddress, privateKey).then((rez) {
          print(rez);
          if (rez != null && rez > -1) {
            Prefs.instance.setStringValue('privateKey', privateKey);
            Prefs.instance.setStringValue('accountAddress', accountAddress);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => new MultiProvider(providers: [
                          ChangeNotifierProvider<ProductsModel>(
                              create: (_) => ProductsModel()),
                          ChangeNotifierProvider<CategoriesModel>(
                              create: (_) => CategoriesModel()),
                          ChangeNotifierProvider<UsersModel>(
                              create: (_) =>
                                  UsersModel(privateKey, accountAddress)),
                        ], child: ConsumerHomePage())),
                (Route<dynamic> route) => false);
          } else {
            switchState();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Uneti podaci su pogrešni')));
          }
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unesite sve podatke')));
      }
    };

    usersModel = Provider.of<UsersModel>(context);
    return Scaffold(
      backgroundColor: Color(BACKGROUND),
      body: (isLoading == true)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinearProgressIndicator(),
                Text('Provera kredencijala...',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(DARK_GREY))),
                SizedBox(height: MediaQuery.of(context).size.height * 0.3)
              ],
            )
          : Center(
              child: SingleChildScrollView(
                  child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0)),
                    SvgPicture.asset('assets/icons/KotaricaLogomark.svg'),
                    SizedBox(height: 20.0),
                    Text('Kotarica',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            color: BACKGROUND == 0xFF000000
                                ? Colors.white
                                : Color(DARK_GREEN)),
                        textAlign: TextAlign.center),
                    SizedBox(height: 40.0),
                    Text(
                      'Kupujte sveže domaće proizvode.',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(DARK_GREY)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('MetaMask adresa',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(DARK_GREY))),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    TextField(
                      style: TextStyle(
                          color: Color(DARK_GREY),
                          fontFamily: 'Inter',
                          fontSize: 16),
                      decoration: InputDecoration(
                          //hintText: 'MetaMask adresa',
                          filled: true,
                          fillColor: Color(LIGHT_GREY),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0))),
                      onChanged: (value) {
                        accountAddress = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Privatni ključ',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(DARK_GREY))),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    PasswordField((val) {
                      privateKey = val;
                    }, '', startLoginRoutine),
                    SizedBox(height: 20.0),
                    ButtonFill(
                      text: 'Prijavi se',
                      onPressed: () {
                        startLoginRoutine();
                      },
                    ),
                    SizedBox(height: 100.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Nemate nalog?',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(DARK_GREY),
                                fontSize: 16),
                            textAlign: TextAlign.center),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new MultiProvider(providers: [
                                        ChangeNotifierProvider<UsersModel>(
                                            create: (_) => UsersModel()),
                                      ], child: SignUp())),
                            );
                          },
                          child: MouseRegion(
                              opaque: true,
                              cursor: SystemMouseCursors.click,
                              child: Text(' Registrujte se. ->',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(TEAL),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center)),
                        )
                      ],
                    )
                  ]),
            ))),

      //resizeToAvoidBottomInset: false
    );
  }
}
