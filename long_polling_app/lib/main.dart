import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int INTERVAL_SEC = 2;
  int _counter = 0;
  Timer _t;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    // Now we want to poll for data right away
    _makeRequestForData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add)),
    );
  }

  _makeRequestForData() {
    // The 10.0.2.2 address allows the android emulator to connect to
    // the localhost on the computer it is running on.
    var url = 'http://10.0.2.2:8000/data';
    http.get(url).then((response) {
      DateTime dt = DateTime.now();
      print("--------------------------------------------");
      print("${dt.minute}:${dt.second}:${dt.millisecond}");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // After receiving the data we want to immediately
      // make the request again
      _makeRequestForData();
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Clean it up at the end
    _t.cancel();
  }
}
