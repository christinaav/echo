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
        primarySwatch: Colors.green,
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
  String temp = "";
  final mycontroller = TextEditingController();

  void dispose() {
    mycontroller.dispose();
    super.dispose();
    print(mycontroller);
  }

  void connect() {
    Socket.connect('192.168.1.195', 3000).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
    });
  }

  void send() {
    Socket.connect('192.168.1.195', 3000).then((socket) {
      socket.listen((List<int> data) {
        // Uint8List
        setState(() {
          print(String.fromCharCodes(data).trim());
          temp = String.fromCharCodes(data).trim();
        });
      });
      //Send the request
      socket.write(mycontroller.text);
    });
    temp = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Server says:',
            ),
            Text(
              '$temp',
              style: Theme.of(context).textTheme.display1,
            ),
            Row(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: connect,
                  child: Icon(Icons.add),
                )
              ],
            ),
            TextField(
              controller: mycontroller,
              decoration: new InputDecoration(
                labelText: "Say something",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(color: Colors.green),
                ),
                suffix: FloatingActionButton(
                  child: Icon(Icons.send),
                  backgroundColor: Colors.green,
                  onPressed: send,
                ),
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
                fontSize: 22.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
