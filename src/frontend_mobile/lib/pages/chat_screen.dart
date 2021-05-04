import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/pages/inbox.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';

class ChatScreen extends StatefulWidget {
  ChatUser user;
  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  _buildMessageComposer() {
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
                cursorColor: Color(TEAL),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 500,
                onChanged: (value) {}, /////////////TODO add_message to value
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
            onPressed:
                () {}, /////////////////TODO submit message(value) to database
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
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(widget.user.photoUrl),
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
                          final Message message = messages[index];
                          final bool isMe = message.sender.id == currentUser.id;
                          return _buildChat(message, isMe);
                        }),
                  )),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
