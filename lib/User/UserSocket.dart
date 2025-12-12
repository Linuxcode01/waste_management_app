import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:waste_management_app/getData.dart';

class UserSocket {
  static final UserSocket _instance = UserSocket._internal();
  factory UserSocket() => _instance;

  late IO.Socket socket;

  UserSocket._internal()  {

    socket = IO.io (
      'http://10.0.2.2:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

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

    // final id = getData.getId();
    //
    // socket.emit("user_connect",{
    //   "userId":id,
    //   "id":socket.id
    // });
  }
}
