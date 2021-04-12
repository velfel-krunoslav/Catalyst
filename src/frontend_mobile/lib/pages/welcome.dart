import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/pages/login.dart';
import 'package:frontend_mobile/pages/sign_up.dart';

import 'package:frontend_mobile/internals.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                //logo
                child: Container(
                  child: ShaderMask(
                    child:
                        SvgPicture.asset('assets/icons/KotaricaLogomark.svg'),
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                          colors: [Color(MINT), Color(TEAL)],
                          stops: [0.2, 0.7]).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                  ),

                  /*child: SvgPicture.asset(
                  'assets/icons/KotaricaLogomark.svg',
                ),*/
                ),
              ), //end logo
              SizedBox(
                height: 10,
              ),
              Text(
                //title
                "Kotarica",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: Color(DARK_GREEN)),
              ), //end title

              SizedBox(height: 40.0),

              Text(
                'Kupujte sveže domaće proizvode.',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(DARK_GREY)),
                textAlign: TextAlign.center,
              ), //end description

              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(height: 70.0),
                      ButtonFill(
                        text: 'Registracija',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new SignUp()),
                          );
                        },
                      ),
                      SizedBox(height: 15.0),
                      ButtonOutline(
                        text: 'Prijava',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Login()),
                          );
                        },
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
