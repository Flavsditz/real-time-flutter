import 'package:eventsource/eventsource.dart';
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
  int _counter = 0;
  EventSource eventSource;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Future<void> initState() {
    super.initState();

    _setUpEventSource();
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

  void _setUpEventSource() async {
    // First we want to register with the server for incoming events
    eventSource = await EventSource.connect("http://10.0.2.2:8000/sse");

    // And for now we are just printing what we get
    eventSource.listen((Event event) {
      printCurrentTime();
      print("  event: ${event.event}");
      print("  data: ${event.data}");
    });
  }

  void printCurrentTime() {
    var dt = new DateTime.now();

    var hour = dt.hour.toString().padLeft(2, "0");
    var minute = dt.minute.toString().padLeft(2, "0");
    var second = dt.second.toString().padLeft(2, "0");
    print("New event at $hour:$minute:$second");
  }

  @override
  void dispose() {
    super.dispose();

    eventSource.client.close();
  }
}
