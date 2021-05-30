import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/usersModel.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../internals.dart';
import '../pages/user_edit.dart';

class MyAccount extends StatefulWidget {
  User user;
  Function editUserCallback;
  MyAccount({this.user, this.editUserCallback});
  @override
  _MyAccountState createState() => _MyAccountState(user);
}

class _MyAccountState extends State<MyAccount> {
  User user;
  _MyAccountState(this.user);

  editProfileCallback2(User u) {
    setState(() {
      user = u;
    });
    widget.editUserCallback(u);
    ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(content: new Text("Informacije su uspešno ažurirane")));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Moj nalog",
            style: TextStyle(fontFamily: 'Inter', color: Color(FOREGROUND)),
          ),
          backgroundColor: Color(BACKGROUND),
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color(FOREGROUND),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new MultiProvider(providers: [
                                ChangeNotifierProvider<UsersModel>(
                                    create: (_) => UsersModel()),
                              ], child: UserEdit(user, editProfileCallback2))));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Color(FOREGROUND),
                        ),
                        child: Image.network(
                          user.photoUrl,
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                  child: Text(
                user.name + " " + user.surname,
                style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 35,
                    fontWeight: FontWeight.w500),
              )),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  user.desc,
                  style: TextStyle(fontFamily: "Inter", fontSize: 17),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    color: Color(LIGHT_GREY)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mail_outline),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            user.email,
                            style: TextStyle(fontFamily: "Inter", fontSize: 17),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.local_phone_outlined),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            user.phoneNumber,
                            style: TextStyle(fontFamily: "Inter", fontSize: 17),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_city_outlined),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            user.homeAddress,
                            style: TextStyle(fontFamily: "Inter", fontSize: 17),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
