import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_svg/svg.dart';
import '../config.dart';
import '../internals.dart';
import '../widgets.dart';

class Settings extends StatefulWidget {
  VoidCallback initiateSetState;

  Settings(this.initiateSetState);

  @override
  _SettingsState createState() => _SettingsState(initiateSetState);
}

class _SettingsState extends State<Settings> {
  Function initiateSetState;

  _SettingsState(this.initiateSetState);

  bool stayLoggedIn = true;
  bool prefersDarkMode = false;
  bool newsletterSubscription = false;

  @override
  void initState() {
    super.initState();
    Prefs.instance.containsKey('stayLoggedIn').then((value) {
      if (value) {
        Prefs.instance.getBooleanValue('stayLoggedIn').then((_value) {
          setState(() {
            stayLoggedIn = _value;
          });
        });
      }
    });

    Prefs.instance.containsKey('prefersDarkMode').then((value) {
      if (value) {
        Prefs.instance.getBooleanValue('prefersDarkMode').then((_value) {
          setState(() {
            prefersDarkMode = _value;
          });
        });
      }
    });

    Prefs.instance.containsKey('newsletterSubscription').then((value) {
      if (value) {
        Prefs.instance.getBooleanValue('newsletterSubscription').then((_value) {
          setState(() {
            newsletterSubscription = _value;
          });
        });
      }
    });
  }

  onSwitchValueChanged(bool value) {
    /*  setState(() {
      _value = value;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Scaffold(
        backgroundColor: Color(BACKGROUND),
        appBar: AppBar(
          title: Text(
            "Podešavanja",
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(DARK_GREY)),
          ),
          backgroundColor: Color(BACKGROUND),
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/ArrowLeft.svg",
                color: Color(FOREGROUND)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(45, 40, 45, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privatnost",
                style: TextStyle(
                    color: Color(DARK_GREY),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Switch(
                      inactiveTrackColor: Color(DARK_GREY),
                      value: stayLoggedIn,
                      activeColor: Color(TEAL),
                      onChanged: (bool value) {
                        setState(() {
                          stayLoggedIn = value;
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Ostanite prijavljeni",
                        style: TextStyle(
                            color: Color(FOREGROUND),
                            fontFamily: 'Inter',
                            fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Pristupačnost",
                style: TextStyle(
                    color: Color(DARK_GREY),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Switch(
                      value: prefersDarkMode,
                      inactiveTrackColor: Color(DARK_GREY),
                      activeColor: Color(TEAL),
                      onChanged: (bool value) {
                        setState(() {
                          prefersDarkMode = value;
                        });
                        Prefs.instance
                            .setBooleanValue('prefersDarkMode', value);
                        if (prefersDarkMode)
                          switchToDarkTheme();
                        else
                          switchToLightTheme();
                        initiateSetState();
                        setState(() {});
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Noćni režim",
                        style: TextStyle(
                            color: Color(FOREGROUND),
                            fontFamily: 'Inter',
                            fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Pretplate",
                style: TextStyle(
                    color: Color(DARK_GREY),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Switch(
                      inactiveTrackColor: Color(DARK_GREY),
                      value: newsletterSubscription,
                      activeColor: Color(TEAL),
                      onChanged: (bool value) {
                        setState(() {
                          newsletterSubscription = value;
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Prijavi me na bilten",
                        style: TextStyle(
                            color: Color(FOREGROUND),
                            fontFamily: 'Inter',
                            fontSize: 16)),
                  ),
                ],
              ),
            ],
            /* children: [
            SettingsOption(
              text: "Privatnost i bezbednost",
              icon: Icon(Icons.lock_outline),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "Uslovi korišćenja",
              icon: Icon(Icons.branding_watermark_sharp),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "Promenite lozinku",
              icon: Icon(Icons.screen_lock_rotation_outlined),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "Plaćanje",
              icon: Icon(Icons.credit_card_outlined),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "O aplikaciji",
              icon: Icon(Icons.description_outlined),
              onPressed: () {},
            ),
          ],*/
          ),
        ),
      );
    });
  }
}
