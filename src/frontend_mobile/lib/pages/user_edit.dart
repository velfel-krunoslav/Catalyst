import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/my_account.dart';
import 'package:frontend_mobile/widgets.dart';
import '../image_picker_helper.dart'
    if (dart.library.html) '../image_picker_web.dart'
    if (dart.library.io) '../image_picker_io.dart';
import '../internals.dart';

class UserEdit extends StatefulWidget {
  User user;
  UserEdit(this.user);
  @override
  _UserEdit createState() => _UserEdit(user);
}

class _UserEdit extends State<UserEdit> {
  User user;
  _UserEdit(this.user);
  Uint8List _image = null;
  final _textControllerInfo = new TextEditingController();
  final _textControllerMail = new TextEditingController();
  final _textControllerPhone = new TextEditingController();
  final _textControllerAdd = new TextEditingController();

  Future getGallery() async {
    getImagePickerMain().getImage().then((value) {
      setState(() {
        _image = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text('Izmena profila',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Odaberite sliku profila:',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Color(BLACK)))
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
                Row(
                  children: [
                    Text('Izmena opisa profila:',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Color(BLACK)))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: BUTTON_HEIGHT + 20,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                          controller: _textControllerInfo,
                          onChanged: (String value) async {
                            setState(() {
                              MyAccount().user.desc = _textControllerInfo.text;
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
                            color: Color(BLACK)))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: BUTTON_HEIGHT,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                          controller: _textControllerMail,
                          onChanged: (String value) async {
                            setState(() {
                              MyAccount().user.email = _textControllerMail.text;
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
                            color: Color(BLACK)))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: BUTTON_HEIGHT,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                          controller: _textControllerPhone,
                          onChanged: (String value) async {
                            setState(() {
                              MyAccount().user.phoneNumber =
                                  _textControllerPhone.text;
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
                            color: Color(BLACK)))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: BUTTON_HEIGHT,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                          controller: _textControllerAdd,
                          onChanged: (String value) async {
                            setState(() {
                              MyAccount().user.homeAddress =
                                  _textControllerAdd.text;
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
                SizedBox(height: 20),
                ButtonFill(
                  text: 'Primeni',
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => new MyAccount()),
                    );
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
