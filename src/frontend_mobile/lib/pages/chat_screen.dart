import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import '../config.dart';
import '../internals.dart';
import '../config.dart';
import '../internals.dart';
import 'inbox.dart';

class ChatScreen extends StatefulWidget {
  ChatUser user;
  ChatUser me;
  int chatID;
  List<Message> messageList;
  int indexToUpdate;
  VoidCallback updateLastMessage;
  ChatScreen(
      {this.user,
      this.me,
      this.chatID,
      this.updateLastMessage,
      this.messageList,
      this.indexToUpdate});

  @override
  _ChatScreenState createState() => _ChatScreenState(
      me: this.me,
      user: this.user,
      chatID: this.chatID,
      updateLastMessage: this.updateLastMessage,
      messageList: this.messageList,
      indexToUpdate: this.indexToUpdate);
}

class _ChatScreenState extends State<ChatScreen> {
  ChatUser user;
  ChatUser me;
  int chatID;
  String tmpMessage;
  List<Message> messages = [];

  List<Message> messageList;
  int indexToUpdate;
  _ChatScreenState(
      {this.user,
      this.me,
      this.chatID,
      this.updateLastMessage,
      this.messageList,
      this.indexToUpdate});

  VoidCallback updateLastMessage;

  @override
  void initState() {
    super.initState();
    requestAllMessagesFromChat(chatID).then((value) {
      var tmp = jsonDecode(value);

      for (var t in tmp) {
        ChatMessageInfo u = ChatMessageInfo.fromJson(t);
        setState(() {
          messages.add(Message(
              senderID: u.fromId,
              time: (u.timestamp.year == DateTime.now().year &&
                      u.timestamp.month == DateTime.now().month &&
                      u.timestamp.day == DateTime.now().day)
                  ? '${u.timestamp.hour.toString().padLeft(2, '0')}:${u.timestamp.minute.toString().padLeft(2, '0')}'
                  : '${u.timestamp.day}.${u.timestamp.month}.${u.timestamp.year}.',
              text: u.messageText,
              unread: u.unread));
        });
      }
    });
  }

  _buildChat(Message message, bool isMe) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, left: (size.width * 0.25))
          : EdgeInsets.only(top: 5.0, bottom: 5.0, right: size.width * 0.25),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        gradient: isMe
            ? LinearGradient(colors: [Color(BACKGROUND), Color(BACKGROUND)])
            : LinearGradient(colors: <Color>[Color(MINT), Color(TEAL)]),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
              ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(message.text,
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: isMe ? Color(FOREGROUND) : Color(BACKGROUND),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 8,
          ),
          Text(
            message.time,
            style: TextStyle(
              fontFamily: 'Inter',
              color: isMe ? Color(FOREGROUND) : Color(BACKGROUND),
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController txt = TextEditingController();

  _buildMessageComposer(ChatUser me) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 86.0,
      color: Color(BACKGROUND),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, top: 6.0),
              child: TextField(
                controller: txt,
                cursorColor: Color(TEAL),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 500,
                onChanged: (value) {
                  tmpMessage = value;
                },
                style: TextStyle(color: Color(FOREGROUND)),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        gapPadding: 0,
                        borderSide: BorderSide(
                          color: Color(TEAL),
                        )),
                    hintText: 'Pošalji poruku...',
                    hintStyle: TextStyle(
                      color: Color(DARK_GREY),
                      fontFamily: 'Inter',
                    )),
              ),
            ),
          ),
          Center(
            child: IconButton(
              icon: Icon(Icons.send),
              iconSize: 24.0,
              color: Color(TEAL),
              onPressed: () {
                if (tmpMessage != null && tmpMessage.compareTo('') != 0) {
                  Message tmpmsg = Message(
                      id: 0,
                      sender: user,
                      senderID: me.id,
                      time:
                          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                      text: tmpMessage,
                      unread: false);

                  if (messageList != null) messageList[indexToUpdate] = tmpmsg;

                  if (updateLastMessage != null) updateLastMessage();

                  setState(() {
                    messages.add(tmpmsg);
                  });

                  Message tmpmsgpub = Message(
                      id: 0,
                      sender: me,
                      senderID: me.id,
                      time: DateTime.now().toIso8601String(),
                      text: tmpMessage,
                      unread: true);
                  publishMessage(tmpmsgpub).then((value) =>
                      print('Response value:${value.statusCode.toString()}'));
                  _scroll.jumpTo(_scroll.position.maxScrollExtent);
                  // TODO NOTIFY ON MESSAGE DELIVERY FAILURE
                  txt.text = '';
                }
              },
            ),
          )
        ],
      ),
    );
  }

  ScrollController _scroll = new ScrollController();

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 104,
        backgroundColor: Color(BACKGROUND),
        leading: IconButton(
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                color: Color(FOREGROUND)),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Container(
          height: 85,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.black,
                  width: 60,
                  height: 60,
                  child: Image.network(widget.user.photoUrl),
                ),
              ),
              Text(
                widget.user.name,
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(FOREGROUND),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(LIGHT_GREY),
                  ),
                  child: ClipRRect(
                    child: ListView.builder(
                        controller: _scroll,
                        dragStartBehavior: DragStartBehavior.down,
                        padding: EdgeInsets.only(top: 25.0),
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          Message message = messages[index];
                          return _buildChat(message, message.senderID == me.id);
                        }),
                  )),
            ),
            _buildMessageComposer(me),
          ],
        ),
      ),
    );
  }
}
