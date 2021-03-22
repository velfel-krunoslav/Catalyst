import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/search_pages.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/pages/sign_up.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: Container(
        width: 300.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0)),
              ShaderMask(
                child: SvgPicture.asset('assets/icons/KotaricaLogomark.svg'),
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                      colors: [Color(MINT), Color(TEAL)],
                      stops: [0.4, 0.6]).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
              ),
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
              TextField(
                  style: TextStyle(
                      color: Color(DARK_GREY),
                      fontFamily: 'Inter',
                      fontSize: 16),
                  decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Color(LIGHT_GREY),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5.0)))),
              SizedBox(height: 20.0),
              TextField(
                style: TextStyle(
                    color: Color(DARK_GREY), fontFamily: 'Inter', fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Lozinka',
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
                text: 'Prijavi se',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new SearchPage()),
                  );
                },
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                  onTap: () {}, // TODO
                  child: Text(
                    'Zaboravili ste lozinku?',
                    style: TextStyle(
                        color: Color(TEAL), fontFamily: 'Inter', fontSize: 16),
                    textAlign: TextAlign.right,
                  )),
              SizedBox(height: 80.0),
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
                        MaterialPageRoute(builder: (context) => new SignUp()),
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
