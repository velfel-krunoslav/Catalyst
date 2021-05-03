import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import '../image_picker_helper.dart'
    if (dart.library.html) '../image_picker_web.dart'
    if (dart.library.io) '../image_picker_io.dart';
import '../internals.dart';
import '../widgets.dart';

class NewProduct extends StatefulWidget {
  Function addProductCallback;
  NewProduct(this.addProductCallback);

  @override
  _NewProductState createState() => _NewProductState(this.addProductCallback);
}

List<Uint8List> images = [];

String name, description;
int selectedUnit, inStock, quantity, imgCount = 0;
double price;
Category selectedCategory;
bool textFld = false;

List<Category> categories = [
  Category(id: 0, name: "Peciva", assetUrl: ""),
  Category(id: 1, name: "Suhomesnato", assetUrl: ""),
  Category(id: 2, name: "Mlečni proizvodi", assetUrl: ""),
  Category(id: 3, name: "Voće i povrće", assetUrl: ""),
  Category(id: 4, name: "Bezalkoholna pića", assetUrl: ""),
  Category(id: 5, name: "Alkohol", assetUrl: ""),
  Category(id: 6, name: "Žita", assetUrl: ""),
  Category(id: 7, name: "Živina", assetUrl: ""),
  Category(id: 8, name: "Zimnice", assetUrl: ""),
  Category(id: 9, name: "Ostali proizvodi", assetUrl: "")
];

class _NewProductState extends State<NewProduct> {
  Function addProductCallback;
  _NewProductState(this.addProductCallback);

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
                Navigator.pop(context);
              },
            )),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(children: [
                      SizedBox(
                        height: 24,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Naziv proizvoda:',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color(DARK_GREY))),
                            SizedBox(
                                height: 48,
                                child: TextField(
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(LIGHT_GREY),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5.0)))))
                          ]),
                      SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Opis proizvoda: (do 200 reči)',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color(DARK_GREY)),
                                textAlign: TextAlign.left),
                            TextField(
                                onChanged: (value) {
                                  description = value;
                                },
                                maxLines: 2,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(LIGHT_GREY),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(5.0)))),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kategorija:',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Color(DARK_GREY))),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                height: 48,
                                width: MediaQuery.of(context).size.width / 2.0 -
                                    40,
                                decoration: BoxDecoration(
                                    color: Color(LIGHT_GREY),
                                    borderRadius: BorderRadius.circular(5)),
                                child: new DropdownButton<Category>(
                                    underline:
                                        Container(color: Colors.transparent),
                                    icon: SvgPicture.asset(
                                        'assets/icons/ArrowDown.svg',
                                        color: Color(DARK_GREY)),
                                    isExpanded: true,
                                    value: selectedCategory,
                                    onChanged: (Category newValue) {
                                      setState(() {
                                        selectedCategory = newValue;
                                      });
                                    },
                                    items: categories.map((Category c) {
                                      return DropdownMenuItem<Category>(
                                          child: Text(c.name,
                                              style: TextStyle(
                                                  color: Color(DARK_GREY),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter')),
                                          value: c);
                                    }).toList()),
                              )
                            ],
                          ),

//na stanju
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trenutno na stanju:',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Color(DARK_GREY))),
                              SizedBox(
                                  height: 48,
                                  width:
                                      MediaQuery.of(context).size.width / 2.0 -
                                          20,
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        inStock = int.parse(value);
                                      },
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(LIGHT_GREY),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(5.0)))))
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jedinica mere:',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Color(DARK_GREY))),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(LIGHT_GREY),
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 48,
                                  width:
                                      MediaQuery.of(context).size.width / 2.0 -
                                          40,
                                  child: DropdownButton(
                                      underline:
                                          Container(color: Colors.transparent),
                                      icon: SvgPicture.asset(
                                          'assets/icons/ArrowDown.svg',
                                          color: Color(DARK_GREY)),
                                      isExpanded: true,
                                      value: selectedUnit,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Komad",
                                              style: TextStyle(
                                                  color: Color(DARK_GREY),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter')),
                                          value: 0,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Masa",
                                              style: TextStyle(
                                                  color: Color(DARK_GREY),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter')),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Zapremina",
                                                style: TextStyle(
                                                    color: Color(DARK_GREY),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter')),
                                            value: 2)
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedUnit = value;
                                          textFld = true;
                                        });
                                      })),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Količina:',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Color(DARK_GREY))),
                              Container(
                                  height: 48,
                                  width:
                                      MediaQuery.of(context).size.width / 2.0 -
                                          20,
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        quantity = int.parse(value);
                                      },
                                      enabled: textFld,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(LIGHT_GREY),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0))))),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cena:',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Color(DARK_GREY))),
                              Container(
                                  height: 48,
                                  width:
                                      MediaQuery.of(context).size.width / 2.0 -
                                          40,
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        price = double.parse(value);
                                      },
                                      enabled: textFld,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(LIGHT_GREY),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0))))),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text('Fotografije (max. 3):',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(DARK_GREY)))
                      ]),
                      SizedBox(height: 10),
                      Row(children: [
                        InkWell(
                            //borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                                color: Color(LIGHT_GREY),
                                height:
                                    (MediaQuery.of(context).size.width - 80) /
                                        4.0,
                                width:
                                    (MediaQuery.of(context).size.width - 80) /
                                        4.0,
                                child: Center(
                                  child: Text('+',
                                      style: TextStyle(
                                          fontSize: 48,
                                          color: Color(DARK_GREY))),
                                )),
                            onTap: () async {
                              final imagePicker = getImagePickerMain();
                              if (imgCount < 3) {
                                imagePicker.getImage().then((bytes) {
                                  setState(() {
                                    images.add(bytes);
                                  });
                                });
                              }
                            }),
                        SizedBox(width: 10),
                        Wrap(
                          children: List.generate(images.length, (index) {
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Image.memory(
                                    images[index],
                                    height: (MediaQuery.of(context).size.width -
                                            80) /
                                        4.0,
                                    width: (MediaQuery.of(context).size.width -
                                            80) /
                                        4.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          }),
                        ),
                      ]),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 60,
                        child: ButtonFill(
                            text: 'Dodaj proizvod',
                            onPressed: () {
                              if (name != null &&
                                  images.length != 0 &&
                                  selectedUnit != null &&
                                  quantity != null &&
                                  description != null &&
                                  selectedCategory != null) {
                                /* addProductCallback(
                                    name,
                                    price,
                                    images, // IPFS GOES HERE
                                    selectedUnit,
                                    quantity,
                                    description,
                                    1, //TODO ADD USER'S ID
                                    selectedCategory.id); */
                                Navigator.pop(context);
                              } else {
                                //TODO istampati poruku da se popune sva polja
                              }
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ])))));
  }
}
