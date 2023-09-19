import 'dart:convert';

import 'package:socket_io_client/src/socket.dart';

class SocketSender {
  late Socket socket;

  void setSocket(Socket socket) {
    this.socket = socket;
  }

  void emit(String event, Map<String, dynamic> data) {
    var sendData = jsonEncode(data);
    print("${socket.id} Sent:\nevent $event\ndata=> $sendData");
    socket.emit(event, sendData);
  }
}
