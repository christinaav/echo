import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'My echo'),
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
  String temp = '';
  String state = '';
  bool connected = false;
  final mycontroller = TextEditingController();
  Socket socketino;

  void connect() {
    temp = 'You are online';
    Socket.connect('192.168.1.195', 3000).then((socket) {
      socketino = socket;
      print('Connected to: '
          '${socketino.remoteAddress.address}:${socketino.remotePort}');

      socketino.listen((List<int> data) {
        // Uint8List
        setState(() {
          print(String.fromCharCodes(data).trim());
          temp = String.fromCharCodes(data).trim();
        });
      });
    });

    connected = true;
  }

  void dispose() {
    mycontroller.dispose();
    super.dispose();
    print(mycontroller);
  }

  void quit() {
    connected = false;
    socketino.destroy();
    temp = 'You are offline';
    mycontroller.clear();
  }

  void send() {
    socketino.write(mycontroller.text);
    print(temp);
    mycontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Switch(
            value: connected,
            onChanged: (connected) {
              setState(() {
                print(connected);
                if (connected) {
                  connect();
                  state = 'You echo is awake.';
                } else {
                  quit();
                  state = 'Your echo is sleeping.';
                }
              });
            },
            activeTrackColor: Colors.white,
            activeColor: Colors.teal,
          ),
        ],
      ),
      backgroundColor: Colors.cyan[50],
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              '$state',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.cyan[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Your echo says:',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$temp',
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.cyan[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            TextField(
              controller: mycontroller,
              decoration: new InputDecoration(
                labelText: "Say something",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(40.0),
                  borderSide: new BorderSide(color: Colors.green),
                ),
                suffix: FloatingActionButton(
                  child: Icon(Icons.send),
                  backgroundColor: Colors.cyan[800],
                  onPressed: send,
                ),
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
