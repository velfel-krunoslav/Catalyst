import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/pages/login.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';

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
                        padding: EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 0.0),
                      ),
                      SvgPicture.asset('assets/icons/KotaricaLogomark.svg',
                          color: Color(TEAL), height: 40.0, width: 40.0),
                      Row(children: <Widget>[
                        Text('Ime:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(DARK_GREY),
                                fontSize: 16)),
                      ]),
                      SizedBox(height: 5.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(children: <Widget>[
                        Text('Prezime:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(DARK_GREY),
                                fontSize: 16)),
                      ]),
                      SizedBox(height: 5.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Text('Datum rođenja:',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(DARK_GREY),
                                  fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      DatePickerPopup(),
                      SizedBox(height: 15.0),
                      Row(children: <Widget>[
                        Text('Broj telefona:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(DARK_GREY),
                                fontSize: 16)),
                      ]),
                      SizedBox(height: 5.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(children: <Widget>[
                        Text('Email:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(DARK_GREY),
                                fontSize: 16)),
                      ]),
                      SizedBox(height: 5.0),
                      Container(
                        height: 50.0,
                        child: TextField(
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 16),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      ButtonFill(
                        text: 'Registruj se',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new ConsumerHomePage()),
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
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ])))));
  }
}
