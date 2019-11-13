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
    Socket.connect('192.168.1.90', 3000).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
    });
  }

  void send() {
    Socket.connect('192.168.1.90', 3000).then((socket) {
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
            TextField(
              controller: mycontroller,
            ),
            Row(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: send,
                  child: Icon(Icons.cast_connected),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          connect();
          /*return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(mycontroller.text),
              );
            },
          );*/
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
