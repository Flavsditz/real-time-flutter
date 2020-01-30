import 'package:flutter/material.dart';
import 'package:websocket_app/chat_page.dart';

class HomePage extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Select a username"),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                controller: _nameController,
              ),
            ),
            RaisedButton(
              child: Text("START"),
              onPressed: () {
                String username = _nameController.text;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChatPage(
                      title: 'OurChat',
                      username: username,
                    ),
                  ),
                );
                _nameController.clear();
              },
            )
          ],
        ),
      ),
    );
  }
}
