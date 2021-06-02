import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../widgets.dart';
import '../pages/login.dart';
import '../pages/sign_up.dart';
import 'package:provider/provider.dart';
import '../models/usersModel.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(BACKGROUND),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                //logo
                child: Container(
                    child:
                        SvgPicture.asset('assets/icons/KotaricaLogomark.svg')),
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
                    color: BACKGROUND == 0xFF000000
                        ? Colors.white
                        : Color(DARK_GREEN)),
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
                                builder: (context) =>
                                    new MultiProvider(providers: [
                                      ChangeNotifierProvider<UsersModel>(
                                          create: (_) => UsersModel()),

                                      // ChangeNotifierProvider<OrdersModel>(
                                      //     create: (_) => OrdersModel()),
                                    ], child: SignUp())),
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
                                builder: (context) =>
                                    new MultiProvider(providers: [
                                      ChangeNotifierProvider<UsersModel>(
                                          create: (_) => UsersModel()),
                                    ], child: Login())),
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
