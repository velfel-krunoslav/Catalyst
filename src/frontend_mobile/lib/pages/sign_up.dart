
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/models/categoriesModel.dart';
import 'package:frontend_mobile/models/ordersModel.dart';
import 'package:frontend_mobile/models/usersModel.dart';
import 'package:frontend_mobile/pages/consumer_cart.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/pages/login.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:provider/provider.dart';
import 'package:frontend_mobile/internals.dart';
import '../models/productsModel.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name;
  DateTime _date;
  String _dateStr;
  String surname;

  String birthday;

  String phone_number;

  String email;

  String metamask_address;
  String homeAddress = "Kralja ptra";
  String private_key;

  bool flg = true;

  UsersModel usersModel;

  @override
  Widget build(BuildContext context) {
    usersModel = Provider.of<UsersModel>(context);
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                      ),
                      Text('Registrujte se',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(DARK_GREY))),
                      SizedBox(height: 20),
                      Container(
                        height: 50.0,
                        child: TextField(
                          onChanged: (value){
                            setState(() {
                              name = value;
                            });
                          },
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Ime',
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          onChanged: (value){
                          setState(() {
                            surname = value;
                          });
                          },
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Prezime',
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(children: [
                        Flexible(
                            child: TextField(
                              // onChanged: (value){
                              //   // setState(() {
                              //   //   birthday = _date.toString();
                              //   //   _dateStr = value;
                              //   // });
                              //
                              // },
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: (_date == null)
                                    ? 'Datum rođenja'
                                    : _date.day.toString() +
                                    '.' +
                                    _date.month.toString() +
                                    '.' +
                                    _date.year.toString() +
                                    '.',
                                filled: true,
                                fillColor: Color(LIGHT_GREY),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            )),
                        SizedBox(width: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              backgroundColor: Color(LIGHT_GREY),
                              minimumSize: Size(BUTTON_HEIGHT, BUTTON_HEIGHT)),
                          child: SvgPicture.asset('assets/icons/CalendarEmpty.svg',
                              color: Color(DARK_GREY),
                              width: INSET_ICON_SIZE,
                              height: INSET_ICON_SIZE),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 320,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            SizedBox(width: 20),
                                            Text(
                                              'Izaberite datum',
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(DARK_GREY),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 24),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 200,
                                          child: CupertinoDatePicker(
                                              initialDateTime:
                                              (_date == null) ? DateTime.now() : _date,
                                              mode: CupertinoDatePickerMode.date,
                                              onDateTimeChanged: (DateTime chosenDate) {
                                                setState(() {
                                                  _date = chosenDate;
                                                });
                                              }),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                              backgroundColor: Color(LIGHT_GREY)),
                                          child: Text(
                                            'Potvrdi',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ]),
                      SizedBox(height: 15.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          onChanged: (value){
                            setState(() {
                              phone_number = value;
                            });
                          },
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Broj telefona',
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          onChanged: (value){
                            setState(() {
                              email = value;
                            });
                          },
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      TextField(
                          onChanged: (value){
                            setState(() {
                              metamask_address = value;
                            });
                          },
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                              hintText: 'MetaMask adresa',
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0)))),
                      SizedBox(height: 15.0),
                      TextField(
                        onChanged: (value){
                          setState(() {
                            private_key = value;
                          });
                        },
                        obscureText: flg,
                        style: TextStyle(
                            color: Color(DARK_GREY),
                            fontFamily: 'Inter',
                            fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Privatni ključ',
                          filled: true,
                          fillColor: Color(LIGHT_GREY),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0)),
                          suffixIcon: IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                            onPressed: () => {flg = !flg},
                            icon: SvgPicture.asset(
                              'assets/icons/EyeSlash.svg',
                              color: Color(DARK_GREY),
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ButtonFill(
                        text: 'Registruj se',
                        onPressed: () {
                          if (name != null && surname!=null && private_key!=null && metamask_address!=null && email!=null && phone_number!=null && _date!=null){
                            //TODO verify private key
                            Prefs.instance.setStringValue("privateKey", private_key);
                            Prefs.instance.setStringValue('accountAddress', metamask_address);
                            birthday = _date.toString();
                            //TODO proveriti da li postoji user sa unesenim kljucem i adresom
                            //TODO regex provera
                            usersModel.createUser(name, surname, private_key, metamask_address, "assets/icons/UserCircle.png", "Opis", email, phone_number, homeAddress, birthday, 0).then((rez){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    new MultiProvider(providers: [
                                      ChangeNotifierProvider<ProductsModel>(
                                          create: (_) => ProductsModel()),
                                      ChangeNotifierProvider<CategoriesModel>(
                                          create: (_) => CategoriesModel()),
                                      ChangeNotifierProvider<UsersModel>(
                                          create: (_) => UsersModel(private_key,metamask_address)),
                                    ], child: ConsumerHomePage())),
                              );
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      new MultiProvider(providers: [
                                        ChangeNotifierProvider<UsersModel>(
                                            create: (_) => UsersModel()),

                                        // ChangeNotifierProvider<OrdersModel>(
                                        //     create: (_) => OrdersModel()),
                                      ], child: Login())),
                                );
                              },
                              child: Text('<- Prijavite se',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(TEAL),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700))),
                          Text(' ukoliko već imate nalog.',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(DARK_GREY),
                                  fontSize: 16))
                        ],
                      )
                    ])))));
  }
}
