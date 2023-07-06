import 'package:socket_io_client/src/socket.dart';

class SocketSender {
  late Socket socket;

  void setSocket(Socket socket) {
    this.socket = socket;
  }

  void emit(String event, data) {
    print("event $event  data=> $data");
    socket.emit(event, data);
  }
}
