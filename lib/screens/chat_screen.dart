
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


final _fireStore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = '/chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextControler = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){

    try{
      final user = _auth.currentUser;
      if(user!=null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('Chat Room')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextControler,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _fireStore.collection('messages').add({
                        'text' : messageText,
                        'sender' : signedInUser.email,
                        'time' : FieldValue.serverTimestamp()
                      });
                      messageTextControler.clear();
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('messages').orderBy('time').snapshots(),
        builder: (context , snapshot){
          List<MessageLine> messageWidgets =[];
          if(!snapshot.hasData){
            return Center(
              child:SpinKitWave(
                color: Colors.orange,
                size: 50.0,
              ),

            );
          }
          final messages = snapshot.data!.docs;
          for(var message in messages){
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = signedInUser.email;
            final messageWidget = MessageLine(sender: messageSender,
              text: messageText,
              isMe: currentUser==messageSender,);
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                children: messageWidgets

            ),
          );
        }
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.text , this.sender ,required this.isMe,Key? key}) : super(key: key);
  final String? sender , text ;
  final bool isMe ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children:[
          Text('$sender',style: TextStyle(color: Colors.yellow.shade900 , fontSize: 12)),
          Material(
            elevation: 5,
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ):BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
    ),

          color: isMe? Colors.blue[800]: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
            child: Text('$text,', style: TextStyle(
                fontSize: 15, color: isMe ? Colors.white:Colors.black45
            ),),
          ),
        ),
      ]
      ),
    );
  }
}

