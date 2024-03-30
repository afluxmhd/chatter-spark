import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class FirebaseChatServer {
  static void sendMessage(types.PartialText message, String id) {
    FirebaseChatCore.instance.sendMessage(message, id);
  }

  static void editMessage(Message message, String roomId) {
    FirebaseChatCore.instance.updateMessage(message as types.Message, roomId);
  }

  static void deleteMessage(String messageId, String roomId) {
    FirebaseChatCore.instance.deleteMessage(roomId, messageId);
  }
}
