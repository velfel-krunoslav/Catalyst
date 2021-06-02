import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../config.dart';
import '../models/categoriesModel.dart';
import '../models/productsModel.dart';
import '../models/usersModel.dart';
import '../widgets.dart';
import '../pages/login.dart';
import 'package:provider/provider.dart';

import '../internals.dart';
import 'consumer_home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<double> textFieldHeight = [
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT
  ];
  String name;
  DateTime _date;
  String surname;

  String birthday;

  String phone_number;

  String email;

  String metamask_address;
  String homeAddress = "Adresa";
  String private_key;
  final _formKey = GlobalKey<FormState>();
  bool isLoading;
  UsersModel usersModel;

  RegExp regEmail = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  RegExp regNum = new RegExp(r"^06[0-69][0-9]{6,7}$");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback startRegisterRoutine = () {
      if (_formKey.currentState.validate()) {
        setState(() {
          this.isLoading = true;
        });

        private_key = private_key.trim();
        metamask_address = metamask_address.trim();

        final client = Web3Client('http://' + HOST, Client(),
            enableBackgroundIsolate: true);
        client.credentialsFromPrivateKey(private_key).then((credentials) =>
            credentials.extractAddress().then((address) {
              if (address.hexNo0x == metamask_address) {
                performPayment(private_key, PUBLIC_KEY, wei: 1, eth: null)
                    .then((credentialsExist) {
                  if (!credentialsExist) {
                    setState(() {
                      this.isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Kombinacija javni-privatni ključ je neispravna.')));
                  } else {
                    Prefs.instance.setStringValue("privateKey", private_key);
                    Prefs.instance
                        .setStringValue('accountAddress', metamask_address);
                    birthday = _date.toString();
                    usersModel
                        .checkForUser(metamask_address, private_key)
                        .then((bl) {
                      if (bl == -1) {
                        usersModel
                            .createUser(
                                name,
                                surname,
                                private_key,
                                metamask_address,
                                "https://ipfs.io/ipfs/QmYCykGuZMMbHcjzJYYJEMYWRrHr5g9gfkUqTkhkaC4gnm",
                                "Opis",
                                email,
                                phone_number,
                                homeAddress,
                                birthday,
                                0)
                            .then((rez) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider<ProductsModel>(
                                              create: (_) => ProductsModel()),
                                          ChangeNotifierProvider<
                                                  CategoriesModel>(
                                              create: (_) => CategoriesModel()),
                                          ChangeNotifierProvider<UsersModel>(
                                              create: (_) => UsersModel(
                                                  private_key,
                                                  metamask_address)),
                                        ],
                                        child: ConsumerHomePage(
                                          reg: true,
                                        ))),
                          );
                        });
                      } else {
                        setState(() {
                          this.isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Nalog sa unetom adresom već postoji.')));
                      }
                    });
                  }
                });
              } else {
                setState(() {
                  this.isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Kombinacija javni-privatni ključ je neispravna.')));
              }

              client.dispose();
            }));
      }
    };

//todo tooltip text
    usersModel = Provider.of<UsersModel>(context);
    return Scaffold(
        backgroundColor: Color(BACKGROUND),
        body: SafeArea(
          child: (isLoading == true)
              ? Column(
                  key: _formKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LinearProgressIndicator(),
                    Text('Kreiranje naloga...',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(DARK_GREY))),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3)
                  ],
                )
              : Center(
                  child: SingleChildScrollView(
                      child: Form(
                  key: _formKey,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                        ),
                        Text('Registrujte se',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(DARK_GREY))),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              height: textFieldHeight[0],
                              width:
                                  MediaQuery.of(context).size.width / 2.0 - 30,
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                  setState(() {
                                    name = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Color(DARK_GREY),
                                    fontFamily: 'Inter',
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    fontFamily: 'Inter',
                                  ),
                                  hintText: 'Ime',
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Container(
                              height: textFieldHeight[1],
                              width:
                                  MediaQuery.of(context).size.width / 2.0 - 30,
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[1] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else {
                                    setState(() {
                                      textFieldHeight[1] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    surname = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Color(DARK_GREY),
                                    fontFamily: 'Inter',
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Prezime',
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: TextFormField(
                                validator: (value) {
                                  if (_date == null) {
                                    return 'Obavezno polje';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: (_date == null)
                                      ? 'Datum rođenja'
                                      : _date.day.toString() +
                                          '.' +
                                          _date.month.toString() +
                                          '.' +
                                          _date.year.toString() +
                                          '.',
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              )),
                              SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0) //                 <--- border radius here
                                      ),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Color(LIGHT_GREY),
                                      minimumSize:
                                          Size(BUTTON_HEIGHT, BUTTON_HEIGHT)),
                                  child: SvgPicture.asset(
                                      'assets/icons/CalendarEmpty.svg',
                                      color: Color(DARK_GREY),
                                      width: INSET_ICON_SIZE,
                                      height: INSET_ICON_SIZE),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 320,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    SizedBox(width: 20),
                                                    Text(
                                                      'Izaberite datum',
                                                      style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color:
                                                              Color(DARK_GREY),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 24),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 200,
                                                  child: CupertinoDatePicker(
                                                      maximumDate:
                                                          DateTime(2010),
                                                      initialDateTime:
                                                          (_date == null)
                                                              ? DateTime(2010)
                                                              : _date,
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .date,
                                                      onDateTimeChanged:
                                                          (DateTime
                                                              chosenDate) {
                                                        setState(() {
                                                          _date = chosenDate;
                                                        });
                                                      }),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 10, 20, 10),
                                                      backgroundColor:
                                                          Color(LIGHT_GREY)),
                                                  child: Text(
                                                    'Potvrdi',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            Color(FOREGROUND),
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ]),
                        SizedBox(height: 15.0),
                        Container(
                          height: textFieldHeight[3],
                          child: TextFormField(
                            keyboardType: TextInputType.number,
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
                                return 'Format: 06XYYYYYYY';
                              } else {
                                setState(() {
                                  textFieldHeight[3] = BUTTON_HEIGHT;
                                });
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                phone_number = value;
                              });
                            },
                            style: TextStyle(
                                color: Color(DARK_GREY),
                                fontFamily: 'Inter',
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Broj telefona',
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          height: textFieldHeight[4],
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  textFieldHeight[4] = BUTTON_HEIGHT + 20;
                                });
                                return 'Obavezno polje';
                              } else if (!regEmail.hasMatch(value)) {
                                setState(() {
                                  textFieldHeight[4] = BUTTON_HEIGHT + 20;
                                });
                                return 'Adresa e-pošte je neispravna';
                              } else {
                                setState(() {
                                  textFieldHeight[4] = BUTTON_HEIGHT;
                                });
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            style: TextStyle(
                                color: Color(DARK_GREY),
                                fontFamily: 'Inter',
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'E-mail',
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          height: textFieldHeight[5],
                          child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    textFieldHeight[5] = BUTTON_HEIGHT + 20;
                                  });
                                  return 'Adresa naloga je neispravna';
                                } else {
                                  setState(() {
                                    textFieldHeight[5] = BUTTON_HEIGHT;
                                  });
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  metamask_address = value;
                                });
                              },
                              style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontFamily: 'Inter',
                                  fontSize: 16),
                              decoration: InputDecoration(
                                  hintText: 'MetaMask adresa',
                                  hintStyle: TextStyle(color: Color(DARK_GREY)),
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(5.0)))),
                        ),
                        SizedBox(height: 15.0),
                        PasswordField((val) {
                          private_key = val;
                        }, 'Privatni ključ', startRegisterRoutine),
                        SizedBox(height: 20.0),
                        ButtonFill(
                          text: 'Registruj se',
                          onPressed: () {
                            startRegisterRoutine();
                          },
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new MultiProvider(providers: [
                                              ChangeNotifierProvider<
                                                      UsersModel>(
                                                  create: (_) => UsersModel()),
                                            ], child: Login())),
                                  );
                                },
                                child: MouseRegion(
                                    opaque: true,
                                    cursor: SystemMouseCursors.click,
                                    child: Text('<- Prijavite se',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(TEAL),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)))),
                            Text(' ukoliko već imate nalog.',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(DARK_GREY),
                                    fontSize: 16))
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        )
                      ])),
                ))),
        ));
  }
}
