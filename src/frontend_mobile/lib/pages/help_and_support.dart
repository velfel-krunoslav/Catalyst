import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config.dart';
import '../internals.dart';
import '../widgets.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

TextEditingController _textController = new TextEditingController();
String chosenValue;
String issueMessage;

Future<bool> sendMail(String issueText) async {
  String username = 'kotaricapmf@gmail.com';
  String password = 'kotarica123';
  bool emailSentCheck;
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, '${usr.name} ${usr.surname}')
    ..recipients.add('korisnickapodrskakotarica@gmail.com')
    ..subject =
        '${usr.name} ${usr.surname} issue:$chosenValue ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}.'
    ..html =
        "<h1>Issue with:$chosenValue</h1>\n<p>User id: ${usr.id}</p><p>User mail: ${usr.email}</p><p>Issue date: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}.</p><p>Issue text:$issueText</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
    emailSentCheck = true;
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
    emailSentCheck = false;
  }

  var connection = PersistentConnection(smtpServer);
  await connection.send(message);
  await connection.close();
  return emailSentCheck;
}

class HelpSupport extends StatefulWidget {
  @override
  _HelpSupportState createState() => _HelpSupportState();
}

List<String> problems = [
  'Prijavom',
  'Zaboravio/la sam svoj privatni ključ',
  'Isporukom proizvoda',
  'Sa slanjem proizvoda',
  'Sa isplatom sredstava'
];

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(BACKGROUND),
      appBar: AppBar(
          title: Text('Pomoć i podrška',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(DARK_GREY))),
          centerTitle: true,
          backgroundColor: Color(BACKGROUND),
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ArrowLeft.svg',
              color: Color(FOREGROUND),
            ),
            onPressed: () {
              _textController.text = '';
              Navigator.pop(context);
            },
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              children: [
                Row(children: [
                  Text('Imam problem sa:',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Color(DARK_GREY)))
                ]),
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
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton(
                              dropdownColor: Color(LIGHT_GREY),
                              underline: Container(color: Colors.transparent),
                              icon: SvgPicture.asset(
                                  'assets/icons/ArrowDown.svg',
                                  color: Color(DARK_GREY)),
                              isExpanded: true,
                              value: chosenValue,
                              onChanged: (newValue) {
                                setState(() {
                                  chosenValue = newValue;
                                });
                              },
                              items: problems.map((valueItem) {
                                return DropdownMenuItem(
                                    child: Text(valueItem,
                                        style: TextStyle(
                                            color: Color(DARK_GREY),
                                            fontSize: 14,
                                            fontFamily: 'Inter')),
                                    value: valueItem);
                              }).toList()),
                        )),
                  ],
                ),
                SizedBox(height: 36),
                Row(children: [
                  Text('Opis problema:',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Color(DARK_GREY)))
                ]),
                SizedBox(height: 10),
                TextField(
                  controller: _textController,
                  style:
                      TextStyle(color: Color(DARK_GREY), fontFamily: 'Inter'),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      //border: OutlineInputBorder(),
                      fillColor: Color(LIGHT_GREY),
                      filled: true),
                  // obscureText: false,
                  maxLength: 250,
                  maxLines: 9,
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  child: ButtonFill(
                      text: 'Pošaljite upit',
                      onPressed: () {
                        if (_textController.text.toString() != '' &&
                            chosenValue != '') {
                          sendMail(_textController.text.toString())
                              .then((emailSent) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        backgroundColor: Color(BACKGROUND),
                                        appBar: AppBar(
                                            backgroundColor: Color(BACKGROUND),
                                            elevation: 0.0,
                                            leading: IconButton(
                                              icon: SvgPicture.asset(
                                                  'assets/icons/ArrowLeft.svg',
                                                  color: Color(FOREGROUND)),
                                              onPressed: () {
                                                int count = 0;
                                                _textController.text = '';
                                                Navigator.of(context).popUntil(
                                                    (_) => count++ >= 2);
                                              },
                                            )),
                                        body: Center(
                                            child: Text(
                                                emailSent != null
                                                    ? 'Uspešno ste poslali upit!'
                                                    : 'Slanje upita neuspešno!',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Inter',
                                                    color:
                                                        Color(FOREGROUND)))))));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Popunite sva polja.')));
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
