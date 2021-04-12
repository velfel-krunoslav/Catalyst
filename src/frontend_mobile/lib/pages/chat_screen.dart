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
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, left: 80.0)
          : EdgeInsets.only(top: 5.0, bottom: 5.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.white : Color(TEAL),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.time,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          Text(message.text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600)),
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
                  hintText: 'Posalji poruku...',
                ),
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
        toolbarHeight: 95,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg'),
            onPressed: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inbox()),
                );
              }
            }),
        title: Padding(
          padding: EdgeInsets.only(left: 100, top: 5),
          child: Container(
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
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                    //borderRadius: BorderRadius.only(
                    //topLeft: Radius.circular(30.0),
                    //topRight: Radius.circular(30.0))
                  ),
                  child: ClipRRect(
                    //borderRadius: BorderRadius.only(
                    //topLeft: Radius.circular(30.0),
                    //topRight: Radius.circular(30.0)),
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
