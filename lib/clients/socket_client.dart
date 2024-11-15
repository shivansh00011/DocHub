// gdocs/clients/socket_client.dart
import 'package:gdocs/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  late final io.Socket socket; // Non-nullable socket instance
  static final SocketClient _instance = SocketClient._internal();

  SocketClient._internal() {
    socket = io.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Set to true if you want auto-connect
    });
    socket.connect(); // Connects manually since autoConnect is false
  }

  static SocketClient get instance => _instance;
}
