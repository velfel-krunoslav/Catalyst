import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../internals.dart';
import '../models/categoriesModel.dart';
import '../models/usersModel.dart';
import '../widgets.dart';
import '../pages/sign_up.dart';
import '../pages/consumer_home.dart';
import 'package:provider/provider.dart';
import '../models/productsModel.dart';

class Login extends StatelessWidget {
  UsersModel usersModel;
  int userId;
  String privateKey = '';
  String accountAddress = '';
  bool flg = true;
  @override
  Widget build(BuildContext context) {
    usersModel = Provider.of<UsersModel>(context);
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Padding(padding: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0)),
          SvgPicture.asset('assets/icons/KotaricaLogomark.svg'),
          SizedBox(height: 20.0),
          Text('Kotarica',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: Color(DARK_GREEN)),
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
                color: Color(DARK_GREY), fontFamily: 'Inter', fontSize: 16),
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
          }, ''),
          SizedBox(height: 20.0),
          ButtonFill(
            text: 'Prijavi se',
            onPressed: () {
              print(privateKey);
              print(accountAddress);
              if (privateKey != null &&
                  privateKey != "" &&
                  accountAddress != null &&
                  accountAddress != "") {
                Prefs.instance.setStringValue('privateKey', privateKey);
                Prefs.instance.setStringValue('accountAddress', accountAddress);

                usersModel.checkForUser(accountAddress, privateKey).then((rez) {
                  print(rez);
                  if (rez != null && rez > -1) {
                    Navigator.push(
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
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Uneti podaci su pogrešni')));
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unesite sve podatke')));
              }
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
                        builder: (context) => new MultiProvider(providers: [
                              ChangeNotifierProvider<UsersModel>(
                                  create: (_) => UsersModel()),
                            ], child: SignUp())),
                  );
                },
                child: Text(' Registrujte se. ->',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(TEAL),
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
              )
            ],
          )
        ]),
      ))),

      //resizeToAvoidBottomInset: false
    );
  }
}
