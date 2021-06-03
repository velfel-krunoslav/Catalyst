import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/usersModel.dart';
import '../config.dart';
import '../pages/my_account.dart';
import '../widgets.dart';
import '../image_picker_helper.dart'
    if (dart.library.html) '../image_picker_web.dart'
    if (dart.library.io) '../image_picker_io.dart';
import '../internals.dart';

class UserEdit extends StatefulWidget {
  User user;
  Function editProfileCallback2;
  UserEdit(this.user, this.editProfileCallback2);
  @override
  _UserEdit createState() => _UserEdit(user);
}

class _UserEdit extends State<UserEdit> {
  bool isLoading = false;
  User user;
  String imageUrl;
  _UserEdit(this.user);
  Uint8List _image = null;
  List<double> textFieldHeight = [
    BUTTON_HEIGHT + 20,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
    BUTTON_HEIGHT,
  ];
  RegExp regEmail = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  RegExp regNum = new RegExp(r"^06[0-69][0-9]{6,7}$");
  final _formKey2 = GlobalKey<FormState>();
  final _textControllerInfo = new TextEditingController(text: usr.desc);
  final _textControllerMail = new TextEditingController(text: usr.email);
  final _textControllerPhone = new TextEditingController(text: usr.phoneNumber);
  final _textControllerAdd = new TextEditingController(text: usr.homeAddress);
  Future getGallery() async {
    getImagePickerMain().getImage().then((value) {
      setState(() {
        _image = value;
      });
    });
  }

  String desc = usr.desc;
  String email = usr.email;
  String phoneNumber = usr.phoneNumber;
  String address = usr.homeAddress;
  UsersModel usersModel;
  Widget build(BuildContext context) {
    usersModel = Provider.of<UsersModel>(context);
    return Scaffold(
        backgroundColor: Color(BACKGROUND),
        appBar: AppBar(
            title: Text('Izmena profila',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/ArrowLeft.svg',
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => new MyAccount()),
                );
              },
            )),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Odaberite sliku profila:',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Color(FOREGROUND)))
                  ],
                ),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: (_image == null)
                                ? Image.network(
                                    widget.user.photoUrl,
                                    fit: BoxFit.fill,
                                  )
                                : Image.memory(_image, fit: BoxFit.cover),
                          )),
                    ),
                    onTap: () {
                      getGallery();
                    },
                  )
                ]),
                SizedBox(height: 20),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Izmena opisa profila:',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  color: Color(FOREGROUND)))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            height: textFieldHeight[0],
                            width: MediaQuery.of(context).size.width - 40,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[0] =
                                          BUTTON_HEIGHT + 20 + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else {
                                    setState(() {
                                      textFieldHeight[0] = BUTTON_HEIGHT + 20;
                                    });
                                  }
                                  return null;
                                },
                                controller: _textControllerInfo,
                                onChanged: (value) {
                                  setState(() {
                                    desc = value;
                                  });
                                },
                                maxLines: 2,
                                style: TextStyle(
                                    color: Color(DARK_GREY),
                                    fontFamily: 'Inter',
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Opis',
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)),
                                )),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Nova e-mail adresa:',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  color: Color(FOREGROUND)))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            height: textFieldHeight[1],
                            width: MediaQuery.of(context).size.width - 40,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[1] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else if (!regEmail.hasMatch(value)) {
                                    setState(() {
                                      textFieldHeight[1] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Adresa e-pošte je neispravna';
                                  } else {
                                    setState(() {
                                      textFieldHeight[1] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
                                controller: _textControllerMail,
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
                                )),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Novi kontakt telefon:',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  color: Color(FOREGROUND)))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            height: textFieldHeight[2],
                            width: MediaQuery.of(context).size.width - 40,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[2] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else if (!regNum.hasMatch(value)) {
                                    setState(() {
                                      textFieldHeight[2] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Format: 06XYYYYYYY';
                                  } else {
                                    setState(() {
                                      textFieldHeight[2] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
                                controller: _textControllerPhone,
                                onChanged: (value) {
                                  setState(() {
                                    phoneNumber = value;
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
                                )),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Nova adresa:',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  color: Color(FOREGROUND)))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            height: textFieldHeight[3],
                            width: MediaQuery.of(context).size.width - 40,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      textFieldHeight[3] = BUTTON_HEIGHT + 20;
                                    });
                                    return 'Obavezno polje';
                                  } else {
                                    setState(() {
                                      textFieldHeight[3] = BUTTON_HEIGHT;
                                    });
                                  }
                                  return null;
                                },
                                controller: _textControllerAdd,
                                onChanged: (value) {
                                  setState(() {
                                    address = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Color(DARK_GREY),
                                    fontFamily: 'Inter',
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Adresa',
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ButtonFill(
                        text: 'Primeni',
                        onPressed: () {
                          if (_formKey2.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            if (_image != null) {
                              asyncFileUpload(_image).then((value) {
                                imageUrl = 'https://ipfs.io/ipfs/$value';
                                usersModel
                                    .editUser(usr.id, imageUrl, desc, email,
                                        phoneNumber, address)
                                    .then((v) {
                                  User user = User(
                                      id: usr.id,
                                      name: usr.name,
                                      surname: usr.surname,
                                      privateKey: usr.privateKey,
                                      metamaskAddress: usr.metamaskAddress,
                                      photoUrl: imageUrl,
                                      desc: desc,
                                      email: email,
                                      phoneNumber: phoneNumber,
                                      homeAddress: address,
                                      birthday: usr.birthday,
                                      uType: usr.uType);
                                  usr = user;
                                  widget.editProfileCallback2(user);
                                  Navigator.pop(context);
                                });
                              });
                            } else {
                              usersModel
                                  .editUser(usr.id, usr.photoUrl, desc, email,
                                      phoneNumber, address)
                                  .then((v) {
                                User user = User(
                                    id: usr.id,
                                    name: usr.name,
                                    surname: usr.surname,
                                    privateKey: usr.privateKey,
                                    metamaskAddress: usr.metamaskAddress,
                                    photoUrl: usr.photoUrl,
                                    desc: desc,
                                    email: email,
                                    phoneNumber: phoneNumber,
                                    homeAddress: address,
                                    birthday: usr.birthday,
                                    uType: usr.uType);
                                usr = user;
                                widget.editProfileCallback2(user);
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                      ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
        )));
  }
}
