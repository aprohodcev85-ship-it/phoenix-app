import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';

class ChatRepository {
  static const String _keyChats = 'chats';

  // Сохранить сообщение в чат
  Future<void> sendMessage(ChatMessageModel message) async {
    final prefs = await SharedPreferences.getInstance();
    final chats = await _loadAllChats();

    var chatMessages = chats[message.chatId];
    if (chatMessages == null) {
      chatMessages = [];
      chats[message.chatId] = chatMessages;
    }

    chatMessages.add(message);

    // Конвертируем Map в список для сохранения
    final List<Map<String, dynamic>> dataToSave = [];
    chats.forEach((chatId, messages) {
      dataToSave.add({
        'id': chatId,
        'messages': messages.map((m) => m.toJson()).toList(),
      });
    });

    await prefs.setString(_keyChats, jsonEncode(dataToSave));
  }

  // Получить все сообщения из конкретного чата
  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    final chats = await _loadAllChats();
    return chats[chatId] ?? [];
  }

  // Получить список всех активных чатов пользователя
  Future<Map<String, String>> getUserChats(String userPhone) async {
    final chats = await _loadAllChats();
    final activeChats = <String, String>{};

    for (var entry in chats.entries) {
      final messages = entry.value;
      if (messages.isEmpty) continue;

      bool hasUser = false;
      for (var msg in messages) {
        if (msg.senderPhone == userPhone) {
          hasUser = true;
          break;
        }
      }

      if (hasUser) {
        activeChats[entry.key] = entry.key;
      }
    }

    return activeChats;
  }

  // Загрузка всех чатов из хранилища
  Future<Map<String, List<ChatMessageModel>>> _loadAllChats() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyChats);

    if (stored == null || stored.isEmpty) {
      return {};
    }

    final List<dynamic> decoded = jsonDecode(stored);
    final Map<String, List<ChatMessageModel>> chats = {};

    for (var item in decoded) {
      final chatId = item['id'];
      final messages = (item['messages'] as List)
          .map((m) => ChatMessageModel.fromJson(m))
          .toList();
      chats[chatId] = messages;
    }

    return chats;
  }
}