import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() => _instance;

  SocketService._internal();

  void initSocket() {
    socket = IO.io(
      // "https://waste-managment-y3tn.onrender.com",
      'http://10.0.2.2:5000', // FIXED URL
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    // 📌 Listeners
    socket.onConnect((_) {
      print("🔥 Socket connected: ${socket.id}");
    });

    socket.onDisconnect((_) {
      print("🔌 Socket disconnected");
    });

    socket.onConnectError((err) {
      print("❌ Connect error: $err");
    });

    socket.onError((err) {
      print("⚠ Socket error: $err");
    });
  }

  // void connect() {
  //   socket.connect();
  // }
  //
  // void disconnect() {
  //   socket.disconnect();
  // }
  //
  // void emit(String eventName, dynamic data, String message) {
  //   socket.emit(eventName, data);
  //   print(message);
  // }
  //
  // void on(String eventName, Function(dynamic) callback) {
  //   socket.on(eventName, callback);
  // }
}