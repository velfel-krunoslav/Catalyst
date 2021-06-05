import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../image_picker_helper.dart'
    if (dart.library.html) '../image_picker_web.dart'
    if (dart.library.io) '../image_picker_io.dart';
import '../internals.dart';
import '../widgets.dart';
import '../internals.dart';

class EditProduct extends StatefulWidget {
  Function editProductCallback;
  Function refreshCallback;
  ProductEntryListingPage product;
  EditProduct(this.product, this.editProductCallback, this.refreshCallback);

  @override
  _EditProductState createState() =>
      _EditProductState(this.product, editProductCallback, refreshCallback);
}

List<double> textFieldHeight = [
  BUTTON_HEIGHT,
  BUTTON_HEIGHT + 80,
  BUTTON_HEIGHT,
  BUTTON_HEIGHT,
  BUTTON_HEIGHT,
  BUTTON_HEIGHT
];
List<String> imagesUrls = [];
RegExp regNum = new RegExp(r"^[0-9]*$");
RegExp regReal = new RegExp(r'^\d+(\.\d+)?$');
String name, description;
int inStock, quantity, imgCount = 0;
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

class _EditProductState extends State<EditProduct> {
  Function editProductCallback;
  Function refreshCallback;
  static GlobalKey<ScaffoldState> _scaffoldKey;
  Function addProductCallback;
  ProductEntryListingPage product;
  _EditProductState(
      this.product, this.editProductCallback, this.refreshCallback);
  bool isSetUnit = true;
  bool isSetCategory = true;
  bool isSetImages = true;
  int selectedUnit;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    for (int i = 0; i < product.assetUrls.length; i++) {
      imagesUrls.add(product.assetUrls[i]);
    }
    selectedCategory = categories[product.categoryId];
    price = product.price;
    name = product.name;
    description = product.description;
    selectedUnit = product.classification.index;
    quantity = product.quantifier;
    inStock = product.inStock;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text('Izmena proizvoda',
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
                          initialValue: product.name,
                          maxLength: 30,
                          maxLengthEnforced: true,
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
                  TextFormField(
                      initialValue: product.description,
                      maxLength: 200,
                      maxLengthEnforced: true,
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
                      minLines: 6,
                      maxLines: 7,
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(LIGHT_GREY),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0)))),
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
                                initialValue: product.quantifier.toString(),
                                maxLength: 10,
                                maxLengthEnforced: true,
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
                                    counterText: "",
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
                                initialValue: inStock.toString(),
                                maxLength: 10,
                                maxLengthEnforced: true,
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
                                    counterText: "",
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
                                initialValue: product.price.toStringAsFixed(2),
                                maxLength: 10,
                                maxLengthEnforced: true,
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
                                    counterText: "",
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
                                imgCount++;
                              });
                              asyncFileUpload(bytes).then((value) {
                                setState(() {
                                  imagesUrls.add('https://ipfs.io/ipfs/$value');
                                });
                              });
                            });
                          } else {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: new Text(
                                    "Ne možete postaviti više od 3 fotografije")));
                          }
                        }),
                    SizedBox(width: 10),
                    (imagesUrls != null && imagesUrls.length != 0)
                        ? Wrap(
                            children: List.generate(imagesUrls.length, (index) {
                              return Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Image.network(
                                          imagesUrls[index],
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80) /
                                              4.0,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80) /
                                              4.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(5),
                                          child: MouseRegion(
                                              opaque: true,
                                              cursor: SystemMouseCursors.click,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    imagesUrls.remove(
                                                        imagesUrls[index]);
                                                    imgCount--;
                                                  });
                                                },
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                      color: Color(BACKGROUND),
                                                      border: Border.all(
                                                          color:
                                                              Color(FOREGROUND),
                                                          width: 1,
                                                          style: BorderStyle
                                                              .solid)),
                                                  child: Center(
                                                    child: Text('-',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                FOREGROUND))),
                                                  ),
                                                ),
                                              )))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              );
                            }),
                          )
                        : SizedBox.shrink()
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
                      text: 'Izmeni proizvod',
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
                        isSetImages = true; //TODO obrisati
                        if (_formKey.currentState.validate() &&
                            isSetCategory &&
                            isSetUnit &&
                            isSetImages) {
                          Classification classif =
                              getClassification(selectedUnit);
                          ProductEntry p = ProductEntry(
                              id: product.id,
                              name: name,
                              price: price,
                              sellerId: usr.id,
                              categoryId: selectedCategory.id,
                              desc: description,
                              assetUrls: imagesUrls,
                              quantifier: quantity,
                              classification: classif,
                              inStock: inStock);
                          editProductCallback(p);
                          refreshCallback(p);
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

  getClassification(int num) {
    if (num == 0) {
      return Classification.Single;
    } else if (num == 1) {
      return Classification.Weight;
    } else {
      return Classification.Volume;
    }
  }
}
