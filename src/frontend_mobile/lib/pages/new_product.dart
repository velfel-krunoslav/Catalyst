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
import '../internals.dart';

class NewProduct extends StatefulWidget {
  Function addProductCallback;

  NewProduct(this.addProductCallback);

  @override
  _NewProductState createState() =>
      _NewProductState(this.addProductCallback);
}

List<Uint8List> images = [];
List<double> textFieldHeight = [
  BUTTON_HEIGHT,
  BUTTON_HEIGHT + 20,
  BUTTON_HEIGHT,
  BUTTON_HEIGHT,
  BUTTON_HEIGHT,
  BUTTON_HEIGHT
];
List<String> imagesUrls = [];
RegExp regNum = new RegExp(r"^[0-9]*$");
RegExp regReal = new RegExp(r'^\d+(\.\d+)?$');
String name, description;
int selectedUnit, inStock, quantity, imgCount = 0;
double price;
Category selectedCategory;
final _formKey = GlobalKey<FormState>();
// TODO PULL CATEGORIES FROM BLOCKCHAIN
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
  static GlobalKey<ScaffoldState> _scaffoldKey;
  Function addProductCallback;
  _NewProductState(this.addProductCallback);
  bool isSetUnit = true;
  bool isSetCategory = true;
  bool isSetImages = true;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                child: Form(
          key: _formKey,
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(children: [
                SizedBox(
                  height: 24,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Naziv proizvoda:',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY))),
                  SizedBox(
                      height: textFieldHeight[0],
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                textFieldHeight[0] = BUTTON_HEIGHT + 20;
                              });
                              return 'Obavezno polje';
                            } else {
                              setState(() {
                                textFieldHeight[0] = BUTTON_HEIGHT;
                              });
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0)))))
                ]),
                SizedBox(height: 5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Opis proizvoda: (do 200 reči)',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY)),
                      textAlign: TextAlign.left),
                  SizedBox(
                    height: textFieldHeight[1],
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              textFieldHeight[1] = BUTTON_HEIGHT + 20 + 20;
                            });
                            return 'Obavezno polje';
                          } else {
                            setState(() {
                              textFieldHeight[1] = BUTTON_HEIGHT + 20;
                            });
                          }
                          return null;
                        },
                        onChanged: (value) {
                          description = value;
                        },
                        maxLines: 2,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)))),
                  ),
                ]),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Količina:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(DARK_GREY))),
                        Container(
                            height: textFieldHeight[4],
                            width: MediaQuery.of(context).size.width / 2.0 - 40,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[4] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else if (!regNum.hasMatch(value)) {
                                    setState(() {
                                      textFieldHeight[4] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Uneti celi broj';
                                  } else {
                                    setState(() {
                                      textFieldHeight[4] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  quantity = int.parse(value);
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(LIGHT_GREY),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(5.0))))),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jedinica mere:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(DARK_GREY))),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              color: Color(LIGHT_GREY),
                              borderRadius: BorderRadius.circular(5)),
                          height: BUTTON_HEIGHT,
                          width: MediaQuery.of(context).size.width / 2.0 - 20,
                          child: DropdownButton(
                              underline: Container(color: Colors.transparent),
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
                                  child: Text("Masa (g)",
                                      style: TextStyle(
                                          color: Color(DARK_GREY),
                                          fontSize: 14,
                                          fontFamily: 'Inter')),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                    child: Text("Zapremina (ml)",
                                        style: TextStyle(
                                            color: Color(DARK_GREY),
                                            fontSize: 14,
                                            fontFamily: 'Inter')),
                                    value: 2)
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedUnit = value;
                                });
                              }),
                        ),
                        !isSetUnit
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                                child: Text(
                                  "Obavezno polje",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red[700]),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          height: BUTTON_HEIGHT,
                          width: MediaQuery.of(context).size.width / 2.0 - 40,
                          decoration: BoxDecoration(
                              color: Color(LIGHT_GREY),
                              borderRadius: BorderRadius.circular(5)),
                          child: new DropdownButton<Category>(
                              underline: Container(color: Colors.transparent),
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
                        ),
                        !isSetCategory
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                                child: Text(
                                  "Obavezno polje",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red[700]),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Na lageru:',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(DARK_GREY))),
                        SizedBox(
                            height: textFieldHeight[3],
                            width: MediaQuery.of(context).size.width / 2.0 - 20,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[3] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else if (!regNum.hasMatch(value)) {
                                    setState(() {
                                      textFieldHeight[3] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Uneti celi broj';
                                  } else {
                                    setState(() {
                                      textFieldHeight[3] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
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
                SizedBox(height: 5),
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
                            height: textFieldHeight[5],
                            width: MediaQuery.of(context).size.width / 2.0 - 40,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[5] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else if (!regReal.hasMatch(value)) {
                                    setState(() {
                                      textFieldHeight[5] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Uneti broj';
                                  } else {
                                    setState(() {
                                      textFieldHeight[5] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  price = double.parse(value);
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(LIGHT_GREY),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(5.0))))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 12, 0, 0),
                      child: Text(CURRENCY,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(DARK_GREY))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Fotografije (max. 3):',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(DARK_GREY))),
                  SizedBox(height: 10),
                  Row(children: [
                    InkWell(
                        //borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                            color: Color(LIGHT_GREY),
                            height:
                                (MediaQuery.of(context).size.width - 80) / 4.0,
                            width:
                                (MediaQuery.of(context).size.width - 80) / 4.0,
                            child: Center(
                              child: Text('+',
                                  style: TextStyle(
                                      fontSize: 48, color: Color(DARK_GREY))),
                            )),
                        onTap: () async {
                          final imagePicker = getImagePickerMain();
                          if (imgCount < 3) {
                            imagePicker.getImage().then((bytes) {
                              setState(() {
                                images.add(bytes);
                                imgCount++;
                              });
                              asyncFileUpload(bytes).then((value) {
                                imagesUrls.add('https://ipfs.io/ipfs/$value');
                              });
                            });
                          } else {
                            _scaffoldKey.currentState
                                .showSnackBar(new SnackBar(content: new Text("Ne možete postaviti više od 3 fotografije")));
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
                                height:
                                    (MediaQuery.of(context).size.width - 80) /
                                        4.0,
                                width:
                                    (MediaQuery.of(context).size.width - 80) /
                                        4.0,
                                fit: BoxFit.cover,
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
                  !isSetImages
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: Text(
                            "Izaberite barem jednu fotografiju",
                            style:
                                TextStyle(fontSize: 12, color: Colors.red[700]),
                          ),
                        )
                      : Container(),
                ]),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  child: ButtonFill(
                      text: 'Dodaj proizvod',
                      onPressed: () {
                        if (selectedUnit == null) {
                          isSetUnit = false;
                        } else {
                          isSetUnit = true;
                        }
                        if (selectedCategory == null) {
                          isSetCategory = false;
                        } else {
                          isSetCategory = true;
                        }
                        if (imagesUrls.length == 0) {
                          isSetImages = false;
                        } else {
                          isSetImages = true;
                        }
                        if (_formKey.currentState.validate() &&
                            isSetCategory &&
                            isSetUnit &&
                            isSetImages) {
                          addProductCallback(
                              name,
                              price,
                              imagesUrls,
                              selectedUnit,
                              quantity,
                              description,
                              usr.id,
                              selectedCategory.id);
                          Navigator.pop(context);
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                )
              ])),
        ))));
  }
}
