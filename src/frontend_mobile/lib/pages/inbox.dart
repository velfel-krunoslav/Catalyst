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
import 'package:flutter/foundation.dart';
import 'chat_screen.dart';

class ChatUser {
  int id;
  int chatID;
  String name;
  String surname;
  String photoUrl;
  ChatUser(
      {@required this.chatID, this.id, this.name, this.surname, this.photoUrl});

  @override
  String toString() {
    return '[${this.id}, ${this.name}, ${this.photoUrl}]';
  }
}

class Message {
  final int id;
  final ChatUser sender;
  final String time;
  final String text;
  bool unread;
  int senderID;

  Message(
      {this.id, this.senderID, this.sender, this.time, this.text, this.unread});

  @override
  String toString() {
    return '[${this.sender}, ${this.time}, ${this.text}, ${this.unread}]';
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({this.messageContent, this.messageType});
}

class Inbox extends StatefulWidget {
  dynamic Function(int id) getUserById;
  Inbox(dynamic Function(int id) getUserById) {
    this.getUserById = getUserById;
  }
  @override
  _UserInboxState createState() => _UserInboxState(this.getUserById);
}

class _UserInboxState extends State<Inbox> {
  dynamic Function(int id) getUserById;
  _UserInboxState(dynamic Function(int id) getUserById) {
    this.getUserById = getUserById;
  }
  List<User> allUsers = [];
  List<ChatUser> contacts = [];
  List<Message> chats = [];

  @override
  void initState() {
    super.initState();
    requestGetChat(usr.id).then((rawData) {
      List<int> partnerIDs = [];
      List<int> chatIDs = [];
      List<ChatInfo> chatInfo = [];
      var tmp = jsonDecode(rawData);
      for (var t in tmp) {
        chatInfo.add(ChatInfo.fromJson(t));
      }
      for (var chat in chatInfo) {
        partnerIDs
            .add((chat.idReciever != usr.id) ? chat.idReciever : chat.idSender);
        chatIDs.add(chat.id);
      }

      for (int index = 0; index < partnerIDs.length; index++) {
        getUserById(partnerIDs[index]).then((userRawData) {
          requestChatID(usr.id, userRawData.id).then((chatID) {
            ChatUser tmpchatuser = ChatUser(
                chatID: int.parse(chatID),
                id: userRawData.id,
                name: '${userRawData.name}',
                surname: '${userRawData.surname}',
                photoUrl: userRawData.photoUrl);

            allUsers.add(userRawData);
            setState(() {
              contacts.add(tmpchatuser);
            });
            requestLatestMessageFromChat(chatIDs[index]).then((value) {
              // TODO CHECK IF RETURN IS NULL
              var msg = ChatMessageInfo.fromJson(jsonDecode(value)[0]);
              Message tmpmsg = Message(
                  id: msg.id,
                  sender: contacts[index],
                  time: (msg.timestamp.year == now.year &&
                          msg.timestamp.month == now.month &&
                          msg.timestamp.day == now.day)
                      ? '${msg.timestamp.hour}:${msg.timestamp.minute}'
                      : '${msg.timestamp.day}.${msg.timestamp.month}.${msg.timestamp.year}.',
                  text: msg.messageText,
                  unread: msg.statusRead);
              setState(() {
                chats.add(tmpmsg);
              });
            });
          });
        });
      }
    });
  }

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
            style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        elevation: 0.0,
      ),
      body: (contacts.length == 0 || (contacts.length != chats.length))
          ? Center(
              child: Text(
              'Nemate započetih\nkonverzacija.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: Color(DARK_GREY)),
            ))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(LIGHT_GREY),
                    ),
                    child: Column(
                      children: <Widget>[
                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Kontakti:",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 90.0,
                              child: Container(
                                height: 90,
                                child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: contacts.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Message chat = chats[index];
                                      return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chats[index].unread = false;
                                            });

                                            setMessageReadStatus(
                                                chat.id, false);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => ChatScreen(
                                                          user: chat.sender,
                                                          chatID:
                                                              contacts[index]
                                                                  .chatID,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Container(
                                                      color: Colors.black,
                                                      width: 50,
                                                      height: 50,
                                                      child: Image.network(
                                                        contacts[index]
                                                            .photoUrl,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                Text(
                                                  contacts[index].name,
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ));
                                    }),
                              ))
                        ]),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              child: ListView.builder(
                                  itemCount: chats.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Message chat = chats[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chats[index].unread = false;
                                        });

                                        setMessageReadStatus(chat.id, false);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ChatScreen(
                                                      user: chat.sender,
                                                      chatID: contacts[index]
                                                          .chatID,
                                                    )));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0, right: 5.0),
                                        decoration: BoxDecoration(
                                          gradient: chat.unread
                                              ? LinearGradient(colors: <Color>[
                                                  Color(TEAL),
                                                  Color(MINT)
                                                ])
                                              : LinearGradient(colors: [
                                                  Colors.white,
                                                  Colors.white
                                                ]),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Container(
                                                      color: Colors.black,
                                                      child: Image.network(
                                                        chat.sender.photoUrl,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${chat.sender.name} ${chat.sender.surname}',
                                                      style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: chat.unread
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Text(
                                                        chat.text,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: chat.unread
                                                              ? Colors.white
                                                              : Color(
                                                                  DARK_GREY),
                                                          fontSize: 16.0,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    chat.time,
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: chat.unread
                                                            ? Color(LIGHT_GREY)
                                                            : Colors.black,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  chat.unread
                                                      ? Container(
                                                          width: 100.0,
                                                          height: 20.0,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  LIGHT_GREY),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0)),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'NOVA PORUKA',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Color(
                                                                    DARK_GREY),
                                                                fontSize: 12.0),
                                                          ),
                                                        )
                                                      : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
