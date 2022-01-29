import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final meassageTextController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isMe;
  String messageText;
  User loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    messagesStream();
  }

  void getCurrentUser() async {
    try {
      var user = await _auth.currentUser;
      loggedInUser = user;
      // print(loggedInUser);
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: Text('Not started chatting yet'),
                    ),
                  );
                }
                final messages = snapshot.data.docs;
                List<Container> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message.get('msg');
                  print(messageText);
                  final messageSender = message.get('user');
                  final currentUser = loggedInUser.email;
                  if (currentUser == messageSender) {
                    isMe = true;
                  }

                  final messageWidget = Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('$messageSender'),
                        Material(
                          elevation: 5.0,
                          color: isMe ? Colors.blueAccent : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              '$messageText',
                              style: TextStyle(
                                fontSize: 20,
                                color: isMe ? Colors.white : Colors.black12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  messageWidgets.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    children: messageWidgets,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: meassageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      meassageTextController.clear();
                      _fireStore.collection('messages').add(
                          {'msg': messageText, 'user': loggedInUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
