import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser muself = ChatUser(id: "1", firstName: "Akshit");
  ChatUser bot = ChatUser(id: "2", firstName: "Agribot");
  List<ChatMessage> allMassages = [];
  List<ChatUser> typing=[];
  // String ApiKey = 'AIzaSyDp_xJVOAyRW9PwpqllwlN_ICE-z-1P37Q';
  final ourUrl="https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDp_xJVOAyRW9PwpqllwlN_ICE-z-1P37Q";
  final header={
    'Content-Type': 'application/json'
  };

  getData(ChatMessage m) async {
    typing.add(bot);
    allMassages.insert(0, m);
    setState(() {

    });
    var data={"contents":[{"parts":[{"text":m.text}]}]};

    await http.post(Uri.parse(ourUrl),headers: header,body: jsonEncode(data)).
    then((value){
      if(value.statusCode==200){
        var result=jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1=ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        allMassages.insert(0, m1);

      }else{
        print("Error occurred");
      }
    }).
    catchError((e){});
    typing.remove(bot);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
        messageOptions: MessageOptions(
            showTime: true,
            textColor: Colors.black,
            containerColor: Colors.grey.shade300
        ),
        typingUsers: typing,
        currentUser: muself,
        onSend: (ChatMessage m) {
          getData(m);
        },
        messages: allMassages,
      ),
    );
  }
}
