import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';

List<ChatMessage> messages = [
  ChatMessage(messageContent: "Zdravo, Petre", messageType: "receiver"),
  ChatMessage(messageContent: "Da li je sir svez?", messageType: "receiver"),
  ChatMessage(messageContent: "Zdravo. Sir je svez...", messageType: "sender"),
  ChatMessage(messageContent: "OK.", messageType: "receiver"),
];

class Inbox extends StatelessWidget {
  ChatUsers data;
  Inbox(ChatUsers data) {
    this.data = data;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Row(
                  children: [
                    IconButton(
                        icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    SizedBox(
                      width: 120,
                    ),
                    CircleAvatar(
                      maxRadius: 36,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage(data.imageURL),
                      ),
                    ),
                    Text(data.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter'))
                  ],
                ),
              ),
            )),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Color(LIGHT_GREY),
                child: Row(
                  children: <Widget>[
                    /*GestureDetector(
                      onTap: () {},
                    )*/
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          hintText: "Unesi poruku...",
                          hintStyle: TextStyle(color: Color(DARK_GREY)),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.send,
                        color: Color(DARK_GREY),
                        size: 18,
                      ),
                      backgroundColor: Color(LIGHT_GREY),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Align(
                      //Text(messages[index].messageContent),
                      alignment: (messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].messageType == "receiver"
                                ? Colors.blue[200]
                                : Colors.grey.shade200),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            messages[index].messageContent,
                            style: TextStyle(fontSize: 15),
                          )),
                    ),
                  );
                }),
            //}),
          ],
        ));
  }
}
