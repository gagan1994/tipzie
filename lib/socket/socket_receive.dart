import 'package:socket_io_client/src/socket.dart';

class SocketReceiver {
  late Socket socket;

  void setSocket(Socket socket) {
    this.socket = socket;
  }
}
