import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/categoriesModel.dart';
import 'package:frontend_mobile/models/ordersModel.dart';

import 'package:frontend_mobile/models/productsModel.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/pages/welcome.dart';

import 'package:provider/provider.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.instance.containsKey('privateKey').then((value) {
    runApp(MaterialApp(
      home: MyApp(value),
    ));
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
    Timer.run(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new MultiProvider(providers: [
                  ChangeNotifierProvider<ProductsModel>(
                      create: (_) => ProductsModel()),
                  ChangeNotifierProvider<CategoriesModel>(
                      create: (_) => CategoriesModel()),
                  ChangeNotifierProvider<OrdersModel>(
                      create: (_) => OrdersModel()),
                ], child: ConsumerHomePage())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShaderMask(
          child: SvgPicture.asset('assets/icons/KotaricaLogomark.svg'),
          shaderCallback: (Rect bounds) {
            return LinearGradient(
                colors: [Color(MINT), Color(TEAL)],
                stops: [0.4, 0.6]).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
        ),
      ),
    );
  }
}
