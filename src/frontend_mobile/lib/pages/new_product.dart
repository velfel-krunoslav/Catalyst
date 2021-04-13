import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../internals.dart';
import '../widgets.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

String chosenValue;
int selected;
bool textFld = false;

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
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Novi proizvod",
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
                    maxLines: 2,
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
                        flex: 8,
                        child: Container(
                          padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          height: 44,
                          decoration: BoxDecoration(
                              color: Color(LIGHT_GREY),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            underline: Container(color: Colors.transparent),
                            icon: SvgPicture.asset('assets/icons/ArrowDown.svg', color: Color(DARK_GREY)),
                            isExpanded: true,
                            value: chosenValue,
                            onChanged: (newValue) {
                              setState(() {
                                chosenValue = newValue;
                              });
                            },
                            items: categories.map((valueItem) {
                              return DropdownMenuItem(
                                child: Text(valueItem, style: TextStyle(color: Color(DARK_GREY), fontSize: 14, fontFamily: 'Inter')),
                                value: valueItem);
                            }).toList()
                          ),
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(width: 5)
                      ),
                      Expanded(
                        flex: 9,
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
                      flex: 8,
                      child: Container(
                        padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(LIGHT_GREY),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton(
                          underline: Container(color: Colors.transparent),
                          icon: SvgPicture.asset('assets/icons/ArrowDown.svg', color: Color(DARK_GREY)),
                          dropdownColor: Color(LIGHT_GREY),
                          isExpanded: true,
                          value: selected,
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "Komad",
                                style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontSize: 14,
                                  fontFamily: 'Inter'
                                )
                              ),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Masa",
                                style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontSize: 14,
                                  fontFamily: 'Inter'
                                )
                              ),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Zapremina",
                                style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontSize: 14,
                                  fontFamily: 'Inter'
                                )
                              ),
                              value: 3
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              selected = value;
                              textFld = true;
                            });
                          })
                        )
                    ),
                    Expanded(
                        flex:1,
                        child: SizedBox(width: 5)
                    ),
                    Expanded(
                      flex: 9,
                      child: SizedBox(
                        child: TextField(
                          enabled: textFld,
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
                      )
                    )
                  ]
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
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
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Container(
                                    height: 250,
                                    child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('Dodajte fotografije proizvoda',
                                                    style: TextStyle(
                                                        color: Color(DARK_GREY),
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18)),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(Icons.photo_camera),
                                                        iconSize: 100,
                                                        onPressed: () {
                                                          _getFromCamera();
                                                        }
                                                    ),
                                                    Text('Kamera',
                                                        style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: 16,
                                                            color: Color(DARK_GREY)
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  child: Column(
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(Icons.photo),
                                                            iconSize: 100,
                                                            onPressed: () {
                                                              _getFromGallery();
                                                            }
                                                        ),
                                                        Text('Galerija',
                                                            style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16,
                                                                color: Color(DARK_GREY)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )
                                            ],
                                          )
                                        ]
                                    )
                                );
                              });
                          //Navigator.pop(context);
                        }
                      ),
                      SizedBox(width: 10),
                      /*InkWell(
                        child: Image.asset(
                          'assets/product_listings/rakija_silverije_cc_by_sa.jpg',
                          height: 80,
                          width: 80
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new Blank() // TODO - SELECT PICTURE TO ADD
                            )
                          );
                        }
                      ),*/
                      //SizedBox(width: 20),
                      /*InkWell(
                        child: Image.asset(
                          'assets/product_listings/salami_pbkwee_by_sa.jpg',
                          height: 80,
                          width: 80
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new Blank() // TODO - SELECT PICTURE TO ADD
                            )
                          );
                        }
                      ),*/
                      imageFiles != null ?
                        Wrap(
                            children: List.generate(imageFiles.length, (index) {
                              return InkWell(
                                  child: SizedBox(
                                    child: new Image.file(
                                      imageFiles[index],
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                              );
                            }
                            )
                        ) : SizedBox()
                    ]
                  )
                ),
                SizedBox(height: 20),
                SizedBox(
                  //width: MediaQuery.of(context).size.width - 40,
                  //height: 60,
                  child: ButtonFill(
                    text: 'Dodaj proizvod',
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            Scaffold(body: Center(child: Text('Uspesno dodat proizvod!')))));
                    }
                  ),
                )
              ])
            )
          )
        )
    );
  }

  List<File> imageFiles = new List<File>();

  _getFromGallery() async {
    var pickedFile = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );
    if (pickedFile != null) {
      setState(() {
        imageFiles.add(pickedFile);
      });
    }
  }

  _getFromCamera() async {
    var pickedFile = await ImagePicker.pickImage(
      source: ImageSource.camera
    );
    if (pickedFile != null) {
      setState(() {
        imageFiles.add(pickedFile);
      });
    }
  }
}