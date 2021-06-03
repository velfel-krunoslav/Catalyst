import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import './config.dart';
import './internals.dart';
import './models/categoriesModel.dart';
import './models/ordersModel.dart';

import './models/productsModel.dart';
import './pages/consumer_home.dart';
import './pages/welcome.dart';

import 'package:provider/provider.dart';

import 'models/usersModel.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.instance.containsKey('privateKey').then((priv) {
    Prefs.instance.containsKey('accountAddress').then((pub) {
      runApp(MaterialApp(
        home: MyApp(priv || pub),
      ));
    });
  });
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  MyApp(this.isLoggedIn);
  @override
  State<StatefulWidget> createState() {
    return MyAppState(this.isLoggedIn);
  }
}

class MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  MyAppState(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: isLoggedIn ? Skip() : Welcome());
  }
}

class Skip extends StatefulWidget {
  @override
  _SkipState createState() => _SkipState();
}

class _SkipState extends State<Skip> {
  @override
  void initState() {
    super.initState();
    Prefs.instance.getStringValue("privateKey").then((value1) {
      Prefs.instance.getStringValue("accountAddress").then((value2) {
        performPayment(value1, PUBLIC_KEY, wei: 1).then((value) {
          Timer.run(() {
            if (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new MultiProvider(providers: [
                          ChangeNotifierProvider<ProductsModel>(
                              create: (_) => ProductsModel()),
                          ChangeNotifierProvider<CategoriesModel>(
                              create: (_) => CategoriesModel()),
                          ChangeNotifierProvider<UsersModel>(
                              create: (_) => UsersModel(value1, value2)),
                        ], child: ConsumerHomePage())),
              );
            } else {
              Prefs.instance.removeAll();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => new Welcome()),
                  (Route<dynamic> route) => false);
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(BACKGROUND),
      body: Center(
          child: SvgPicture.asset('assets/icons/KotaricaLogomark.svg',
              color: (BACKGROUND == 0xFF000000) ? Colors.white : null)),
    );
  }
}
