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
  String temp;

  void connect() {
    String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';
    setState(() {
      Socket.connect("192.168.43.242", 3000).then((socket) {
        /*print('*** Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
*/
        socket.listen((List<int> data) {
          // Uint8List
          print(String.fromCharCodes(data).trim());
          temp = String.fromCharCodes(data).trim();
        }, onDone: () {
          socket.destroy();
        });

        //Send the request
        socket.write(indexRequest);
      });
    });
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
              'Server says:',
            ),
            Text(
              '$temp',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: connect,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
