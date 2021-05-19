import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/pages/inbox.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';

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
            ? LinearGradient(colors: [Colors.white, Colors.white])
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
                  color: isMe ? Colors.black : Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 8,
          ),
          Text(
            message.time,
            style: TextStyle(
              fontFamily: 'Inter',
              color: isMe ? Colors.black : Colors.white,
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
      height: 80.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: TextField(
                controller: txt,
                cursorColor: Color(TEAL),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 500,
                onChanged: (value) {
                  tmpMessage = value;
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(TEAL),
                    )),
                    hintText: 'Pošalji poruku...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                    )),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
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

                messageList[indexToUpdate] = tmpmsg;

                updateLastMessage();

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
                txt.text = '';
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 95,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg'),
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
                    color: Colors.black,
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
                        //reverse: true,
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
