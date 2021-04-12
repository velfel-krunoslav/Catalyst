import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/search_pages.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/pages/login.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:provider/provider.dart';

import '../models/productsModel.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      DatePickerPopup(),
                      SizedBox(height: 15.0),
                      Container(
                        height: 50.0,
                        child: TextField(
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
                            onPressed: () => {},
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new ChangeNotifierProvider(
                                        create: (context) => ProductsModel(),
                                        child: ConsumerHomePage())),
                          );
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
                                      builder: (context) => new Login()),
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
