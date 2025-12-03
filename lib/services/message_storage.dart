import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_messaging_app/models/message.dart';

class MessageStorage {
  static const String _storageKey = 'chat_messages_v1';

  Future<void> saveMessages(List<Message> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = messages.map((msg) => msg.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  Future<List<Message>> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading messages: $e');
      return [];
    }
  }
}
