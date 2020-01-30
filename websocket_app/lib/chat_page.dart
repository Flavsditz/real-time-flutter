import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:websocket_app/message.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final String username;

  ChatPage({Key key, this.title, this.username}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _chatController = TextEditingController();
  IOWebSocketChannel channel;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();

    _setUpWebsocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: channel != null
            ? StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');

                  _messages.add(Message.fromJson(jsonDecode(snapshot.data)));

                  return ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        Message msg = _messages[index];

                        if (msg.sender == "Server") {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.yellow[100],
                                ),
                                child: Text("${msg.timestamp} - ${msg.data}"),
                              ),
                            ),
                          );
                        }

                        return ListTile(
                          title: Text(msg.sender),
                          subtitle: Text(msg.data),
                          trailing: Text(msg.timestamp),
                        );
                      });
                },
              )
            : Text("Connecting..."),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(12),
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _chatController,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                channel.sink.add(_chatController.text);
                _chatController.clear();
              },
              child: Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }

  void _setUpWebsocket() async {
    channel = IOWebSocketChannel.connect(
      "ws://10.0.2.2:8000/chat",
      headers: {
        "username": widget.username,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _chatController.dispose();
    channel.sink.close(status.goingAway);
  }
}
