import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import '../widgets.dart';

class Settings extends StatelessWidget {
  bool _value = false;
  onSwitchValueChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Scaffold(
        backgroundColor: Color(LIGHT_GREY),
        appBar: AppBar(
          title: Text(
            "Podešavanja",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(45, 40, 45, 30),
          child: Column(
            children: [
              Text(
                "Privatnost",
                style: TextStyle(
                    color: Color(BLACK),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                      value: _value,
                      activeColor: Color(BLACK),
                      onChanged: (bool value) {
                        stateSetter(() => onSwitchValueChanged(value));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Ostanite prijavljeni:",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 14)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                      value: _value,
                      activeColor: Color(BLACK),
                      onChanged: (bool value) {
                        stateSetter(() => onSwitchValueChanged(value));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Zatraži otključavanje ekrana:",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 14)),
                  ),
                ],
              ),
              Text(
                "Pristupačnost",
                style: TextStyle(
                    color: Color(BLACK),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                      value: _value,
                      activeColor: Color(BLACK),
                      onChanged: (bool value) {
                        stateSetter(() => onSwitchValueChanged(value));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Noćni režim:",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 14)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                      value: _value,
                      activeColor: Color(BLACK),
                      onChanged: (bool value) {
                        stateSetter(() => onSwitchValueChanged(value));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Režim visokog kontrasta:",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 14)),
                  ),
                ],
              ),
              Text(
                "Pretplate",
                style: TextStyle(
                    color: Color(BLACK),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                      value: _value,
                      activeColor: Color(BLACK),
                      onChanged: (bool value) {
                        stateSetter(() => onSwitchValueChanged(value));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("Prijavi me na bilten:",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 14)),
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
