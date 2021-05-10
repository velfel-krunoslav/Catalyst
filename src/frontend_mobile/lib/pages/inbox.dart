import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/productsModel.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ChatUser {
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

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({this.messageContent, this.messageType});
}

ChatUser currentUser = ChatUser(
  id: 0,
  name: 'Trenutni user',
  photoUrl:
      'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
);
ChatUser jelena = ChatUser(
  id: 1,
  name: 'Jelena',
  photoUrl:
      'https://ipfs.io/ipfs/QmVZd57UK4FDVMF46bagh8wQmZtMAHGTDfLGYHXoD93R5P',
);
ChatUser luka = ChatUser(
  id: 2,
  name: 'Luka',
  photoUrl:
      'https://ipfs.io/ipfs/QmcAwtzGN2mgaMcnr1cZuHNBY4QRQZ3pskvKsQ66CFrTNX',
);
ChatUser marija = ChatUser(
  id: 3,
  name: 'Marija',
  photoUrl:
      'https://ipfs.io/ipfs/QmSW4mVxnb7uzStRZCpr8bo5qN3agmDwNZCJxHC737PtHw',
);
ChatUser pera = ChatUser(
  id: 4,
  name: 'Slobodanka',
  photoUrl:
      'https://ipfs.io/ipfs/QmUTVasG46ddZJvcVnoYKrwMjNDc8JYuQdHTpurszoNKFh',
);
ChatUser krunoslav = ChatUser(
  id: 5,
  name: 'Krunoslav',
  photoUrl:
      'https://ipfs.io/ipfs/QmR2Q46xBJesQKiBbGZtJYwvq4KH1hqxavmr9U5d98fbqr',
);
ChatUser stefan = ChatUser(
  id: 6,
  name: 'Stefan',
  photoUrl:
      'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
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
    requestGetChat(1).then((value) {
      Map<String, dynamic> chat = jsonDecode(value);
      print('ID:${chat['id']}');
      print('ID_SENDER:${chat['id_Sender']}');
      print('ID_RECIEVER:${chat['id_Reciever']}');
    });
    requestAllChatsForUserID(1).then((value) {
      //Map<String, dynamic> chat = jsonDecode(value);
    });

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
            style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        elevation: 0.0,
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
