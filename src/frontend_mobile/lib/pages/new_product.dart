import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/models/productsModel.dart';
import 'package:provider/provider.dart';

import '../internals.dart';
import '../widgets.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

class NewProduct extends StatefulWidget {
  Function addProductCallback;
  NewProduct(this.addProductCallback);

  @override
  _NewProductState createState() => _NewProductState(this.addProductCallback);
}

String chosenValue;
int selected;
bool textFld = false;

TextEditingController nameController = new TextEditingController();
TextEditingController descriptionController = new TextEditingController();
TextEditingController inStockController = new TextEditingController();
int measure = 0;
TextEditingController amountController = new TextEditingController();

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
Category selectedCategory;
double price;
List<String> images = [
  "assets/product_listings/rakija_silverije_cc_by_sa.jpg",
  "assets/product_listings/salami_pbkwee_by_sa.jpg"
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
                      Row(children: [
                        Text('Naziv proizvoda:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(DARK_GREY)))
                      ]),
                      SizedBox(height: 10),
                      SizedBox(
                          child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(5.0)))),
                          height: 44,
                          width: MediaQuery.of(context).size.width - 40),
                      SizedBox(height: 20),
                      Row(children: [
                        Text('Opis proizvoda: (do 200 reči)',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(DARK_GREY)),
                            textAlign: TextAlign.left)
                      ]),
                      SizedBox(height: 10),
                      SizedBox(
                          child: TextField(
                              controller: descriptionController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(5.0)))),
                          width: MediaQuery.of(context).size.width - 40),
                      SizedBox(height: 20),
                      Row(children: [
                        Expanded(
                          flex: 1,
                          child: Text('Kategorija:',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Color(DARK_GREY))),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text('Trenutno na stanju:',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color(DARK_GREY))))
                      ]),
                      SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            flex: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              height: 44,
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
                            )),
                        Expanded(flex: 1, child: SizedBox(width: 5)),
                        Expanded(
                            flex: 9,
                            child: SizedBox(
                                child: TextField(
                                    controller: inStockController,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(LIGHT_GREY),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5.0)))),
                                height: 44,
                                width: 142))
                      ]),
                      SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            flex: 1,
                            child: Text('Jedinica mere:',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color(DARK_GREY)))),
                        Expanded(
                            flex: 1,
                            child: Text('Količina:',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color(DARK_GREY))))
                      ]),
                      SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            flex: 8,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                height: 44,
                                decoration: BoxDecoration(
                                    color: Color(LIGHT_GREY),
                                    borderRadius: BorderRadius.circular(5)),
                                child: DropdownButton(
                                    underline:
                                        Container(color: Colors.transparent),
                                    icon: SvgPicture.asset(
                                        'assets/icons/ArrowDown.svg',
                                        color: Color(DARK_GREY)),
                                    dropdownColor: Color(LIGHT_GREY),
                                    isExpanded: true,
                                    value: selected,
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
                                        selected = value;
                                        textFld = true;
                                      });
                                    }))),
                        Expanded(flex: 1, child: SizedBox(width: 5)),
                        Expanded(
                            flex: 9,
                            child: SizedBox(
                                child: TextField(
                                    controller: amountController,
                                    enabled: textFld,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(LIGHT_GREY),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5.0)))),
                                height: 44,
                                width: 142))
                      ]),
                      SizedBox(height: 20),
                      Row(children: [
                        Text('Fotografije: (max. 5)',
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
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: Text('+',
                                      style: TextStyle(
                                          fontSize: 48,
                                          color: Color(DARK_GREY))),
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new Blank() // TODO - ADD PICTURES
                                      ));
                            }),
                        SizedBox(width: 10),
                        Wrap(
                          children: List.generate(images.length, (index) {
                            return InkWell(
                                child: SizedBox(
                                  child: Image.asset(
                                    images[index],
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new Blank() // TODO - SELECT PICTURE TO ADD
                                          ));
                                });
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
                              price = 2.33;
                              if (nameController.text != null &&
                                  images.length != 0 &&
                                  selected != null &&
                                  amountController.text != null &&
                                  descriptionController.text != null &&
                                  selectedCategory != null) {
                                addProductCallback(
                                    nameController.text,
                                    price,
                                    images,
                                    selected,
                                    int.parse(amountController.text),
                                    descriptionController.text,
                                    1,
                                    selectedCategory.id);
                                Navigator.pop(context);
                              } else {
                                //TODO istampati poruku da se popune sva polja
                              }
                            }),
                      )
                    ])))));
  }
}
