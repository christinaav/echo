import 'dart:io';

void main() {
  ServerSocket.bind('192.168.1.195', 3000).then((ServerSocket server) {
    server.listen(handleClient);
  });
}

void handleClient(Socket client) {
  print('Connection from ' +
      '${client.remoteAddress.address}:${client.remotePort}');
  client.listen((data) {
    String str = String.fromCharCodes(data).trim();
    print(str);
    client.write(str + '\n');
  });

  void quit() {
    client.destroy();
  }
}
