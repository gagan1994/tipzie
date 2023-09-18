import 'dart:convert';

import 'package:socket_io_client/src/socket.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';

class SocketReceiver {
  late Socket socket;
  void setSocket(Socket socket) {
    this.socket = socket;
  }

  void listen(String event, EventHandler callback) {
    print("subscribing topic: $event");
    socket.on(event, (data) {
      print("received:\nevent:$event\ndata $data ");
      if (data is String) {
        callback(jsonDecode(data));
      } else {
        callback(data);
      }
    });
  }
}
