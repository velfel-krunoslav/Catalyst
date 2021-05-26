import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';

import '../internals.dart';
import '../widgets.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

class HelpSupport extends StatefulWidget {
  @override
  _HelpSupportState createState() => _HelpSupportState();
}

String chosenValue;

List<String> problems = [
  'Prijavom',
  'Zaboravio/la sam svoj privatni ključ',
  'Isporukom proizvoda',
  'Sa slanjem proizvoda',
  'Sa isplatom sredstava'
];

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Pomoć i podrška',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(DARK_GREY))),
          centerTitle: true,
          backgroundColor: Color(BACKGROUND),
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ArrowLeft.svg',
              height: ICON_SIZE,
              width: ICON_SIZE,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              children: [
                Row(children: [
                  Text('Imam problem sa:',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Color(DARK_GREY)))
                ]),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          height: 44,
                          decoration: BoxDecoration(
                              color: Color(LIGHT_GREY),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton(
                              underline: Container(color: Colors.transparent),
                              icon: SvgPicture.asset(
                                  'assets/icons/ArrowDown.svg',
                                  color: Color(DARK_GREY)),
                              isExpanded: true,
                              value: chosenValue,
                              onChanged: (newValue) {
                                setState(() {
                                  chosenValue = newValue;
                                });
                              },
                              items: problems.map((valueItem) {
                                return DropdownMenuItem(
                                    child: Text(valueItem,
                                        style: TextStyle(
                                            color: Color(DARK_GREY),
                                            fontSize: 14,
                                            fontFamily: 'Inter')),
                                    value: valueItem);
                              }).toList()),
                        )),
                  ],
                ),
                SizedBox(height: 36),
                Row(children: [
                  Text('Opis problema:',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Color(DARK_GREY)))
                ]),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      //border: OutlineInputBorder(),
                      fillColor: Color(LIGHT_GREY),
                      filled: true),
                  // obscureText: false,
                  maxLength: 250,
                  maxLines: 9,
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  child: ButtonFill(
                      text: 'Pošaljite upit',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                        backgroundColor: Color(BACKGROUND),
                                        elevation: 0.0,
                                        leading: IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/icons/ArrowLeft.svg',
                                            height: ICON_SIZE,
                                            width: ICON_SIZE,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )),
                                    body: Center(
                                        child: Text('Uspešno ste poslali upit!',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                color: Color(BLACK)))))));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
