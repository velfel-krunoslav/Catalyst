import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/productsModel.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatUser extends User {
  int id;
  String name;
  String photoUrl;
  ChatUser({this.id, this.name, this.photoUrl});
}

class Message {
  final ChatUser sender;
  final String time;
  final String text;
  bool unread;

  Message({this.sender, this.time, this.text, this.unread});
}

ChatUser currentUser = ChatUser(
  id: 0,
  name: 'Trenutni user',
  photoUrl: 'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
);
ChatUser jelena = ChatUser(
  id: 1,
  name: 'Jelena',
  photoUrl: 'assets/avatars/avatar2.jpg',
);
ChatUser luka = ChatUser(
  id: 2,
  name: 'Luka',
  photoUrl: 'assets/avatars/avatar1.jpg',
);
ChatUser marija = ChatUser(
  id: 3,
  name: 'Marija',
  photoUrl: 'assets/avatars/avatar3.jpg',
);
ChatUser pera = ChatUser(
  id: 4,
  name: 'Slobodanka',
  photoUrl: 'assets/avatars/avatar4.jpg',
);
ChatUser krunoslav = ChatUser(
  id: 5,
  name: 'Krunoslav',
  photoUrl: 'assets/avatars/avatar5.jpg',
);
ChatUser stefan = ChatUser(
  id: 6,
  name: 'Stefan',
  photoUrl: 'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
);

List<ChatUser> contacts = [jelena, luka, marija, pera, krunoslav, stefan];

DateTime now = DateTime.now();
String formattedDate = DateFormat('kk:mm').format(now);

List<Message> chats = [
  Message(sender: jelena, time: formattedDate, text: 'Hey?', unread: true),
  Message(
      sender: luka,
      time: formattedDate,
      text: 'Jesam li parsirao?',
      unread: false),
  Message(
      sender: marija,
      time: formattedDate,
      text: 'Posto je paprika,druze?',
      unread: true),
  Message(sender: jelena, time: formattedDate, text: 'Desi?', unread: false),
  Message(
      sender: stefan,
      time: formattedDate,
      text: '.................',
      unread: false),
  Message(sender: krunoslav, time: formattedDate, text: 'stres', unread: true),
  Message(sender: pera, time: formattedDate, text: 'zdera', unread: false),
  Message(sender: jelena, time: formattedDate, text: 'Hey', unread: true),
  Message(sender: luka, time: formattedDate, text: 'Parsiraj', unread: false),
  Message(sender: marija, time: formattedDate, text: 'Aloee', unread: true),
  Message(sender: jelena, time: formattedDate, text: 'Desi', unread: false),
  Message(sender: stefan, time: formattedDate, text: '...', unread: false),
  Message(
      sender: krunoslav, time: formattedDate, text: 'helloouuu', unread: true),
  Message(
      sender: pera,
      time: formattedDate,
      text: 'Sta je bre ovo?',
      unread: false),
];

List<Message> messages = [
  Message(sender: luka, time: '5:30', text: 'Jesam li parsirao?', unread: true),
  Message(
      sender: currentUser, time: '5:30', text: 'Nisi parsirao!', unread: true),
  Message(
    sender: luka,
    time: '5:31',
    text: 'Posto paradajz?',
    unread: true,
  ),
  Message(
      sender: currentUser,
      time: '5:38',
      text: '150 dinara kilo!',
      unread: true),
  Message(
      sender: luka,
      time: '8:30',
      text: 'Skup si brate,moze popust?',
      unread: true),
  Message(
      sender: currentUser,
      time: '8:32',
      text: 'Moze,dajem 10% za tebe popusta!',
      unread: true),
  Message(
      sender: luka,
      time: '9:00',
      text:
          'Moze salji na sledecu adresu: Radoja Domanovica 1,Kragujevac,34000',
      unread: true),
  Message(sender: currentUser, time: '9:11', text: 'Dogovoreno!', unread: true),
];

class Inbox extends StatefulWidget {
  @override
  _UserInboxState createState() => _UserInboxState();
}

class _UserInboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg'),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Poruke',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                //////////////TODO Search contacts
                //Navigator.pop(context);
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(LIGHT_GREY),
              ),
              child: Column(
                children: <Widget>[
                  Contacts(),
                  Chats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
