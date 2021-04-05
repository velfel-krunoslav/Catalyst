import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';

import '../internals.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

String chosenValue;
int selected = 1;

List<String> categories = [
  'Peciva',
  'Suhomesnato',
  'Mlečni proizvodi',
  'Voće i povrće',
  'Bezalkoholna pića',
  'Alkohol',
  'Žita',
  'Živina',
  'Zimnice',
  'Ostali proizvodi'
];

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text('Novi proizvod',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(DARK_GREY))),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/ArrowLeft.svg',
                height: ICON_SIZE,
                width: ICON_SIZE,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsumerHomePage()),
                );
              },
            )),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: 
              Column( children: [
                Row( children: [
                  Text('Naziv proizvoda:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(DARK_GREY)
                    )
                  )
                ]),
                SizedBox(height: 10),
                SizedBox(
                  child: TextField(
                    decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(LIGHT_GREY),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0))
                    )
                  ),
                  height: 44,
                  width: MediaQuery.of(context).size.width - 40
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Opis proizvoda: (do 200 reči)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(DARK_GREY)
                    ),
                    textAlign: TextAlign.left
                  )]
                ),
                SizedBox(height: 10),
                SizedBox(
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(LIGHT_GREY),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0))
                    )
                  ),
                  width: MediaQuery.of(context).size.width - 40
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Kategorija:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY)
                        )
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Trenutno na stanju:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY)
                        )
                      )
                    )
                  ]
                ),
                SizedBox(height: 10),
                Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: DropdownButton(
                          value: chosenValue,
                          onChanged: (newValue) {
                            setState(() {
                              chosenValue = newValue;
                            });
                          },
                          items: categories.map((valueItem) {
                            return DropdownMenuItem(
                              child: Text(valueItem),
                              value: valueItem);
                          }).toList()
                        )
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(LIGHT_GREY),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0))
                              )
                            ),
                            height: 44,
                            width: 142
                          )
                      )
                    ]
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Jedinica mere:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY)
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Količina:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY)
                        )
                      )
                    )
                  ]
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButton(
                          value: selected,
                          items: [
                            DropdownMenuItem(
                              child: Text("Komad"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Težina"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                                child: Text("Zapremina"),
                                value: 3
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selected = value;
                            });
                          })
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0))
                          )
                        ),
                        height: 44,
                        width: 142
                      )
                    )
                  ]
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Fotografije: (max. 5)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(DARK_GREY)
                      ))
                  ]
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      //borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        color: Color(LIGHT_GREY),
                        height: 80,
                        width: 80,
                        child: Center(
                          child: Text('+', style: TextStyle(fontSize: 48, color: Color(DARK_GREY))),
                        )
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Blank() // TODO ADD PICTURES
                            )
                        );
                      }
                    ),
                    SizedBox(width: 10),
                    InkWell(
                        child: Image.asset(
                            'assets/product_listings/rakija_silverije_cc_by_sa.jpg',
                            height: 80,
                            width: 80
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      context) => new Blank() // TODO SELECT PICTURE
                              )
                          );
                        }
                    ),
                    //SizedBox(width: 20),
                    InkWell(
                        child: Image.asset(
                            'assets/product_listings/salami_pbkwee_by_sa.jpg',
                            height: 80,
                            width: 80
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      context) => new Blank() // TODO SELECT PICTURE
                              )
                          );
                        }
                    )
                  ]
                )
              ])
            )
          )
        )
    );
  }
  
}