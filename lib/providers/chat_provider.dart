import 'package:flutter/material.dart'; 
import 'package:hive/hive.dart'; 
import '../models/chat.dart'; 
import '../models/message.dart'; 

// Класс провайдера для управления состоянием чатов и сообщений
class ChatProvider with ChangeNotifier {
  late final Box<Chat> _chatsBox; // Хранилище чатов
  late final Box<Message> _messagesBox; // Хранилище сообщений

  // Конструктор класса, инициализирует хранилища
  ChatProvider() {
    _initBoxes();
  }

  // Метод для инициализации хранилищ Hive
  Future<void> _initBoxes() async {
    _chatsBox = Hive.box<Chat>('chats'); // Инициализация хранилища чатов
    _messagesBox = Hive.box<Message>('messages'); // Инициализация хранилища сообщений
    notifyListeners(); // Уведомляем слушателей об изменениях
  }

  // Получение списка чатов, отсортированных по времени последнего сообщения
  List<Chat> get chats => _chatsBox.values
      .toList()
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

  // Метод для добавления нового чата
  Future<void> addChat(Chat chat) async {
    await _chatsBox.put(chat.id, chat); // Добавляем чат в хранилище
    notifyListeners(); // Уведомляем слушателей об изменениях
  }

  // Получение сообщений для конкретного чата, отсортированных по времени
  List<Message> getMessagesForChat(String chatId) {
    return _messagesBox.values
        .where((message) => message.chatId == chatId) // Фильтруем сообщения по ID чата
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Сортируем по времени
  }

  // Метод для добавления нового сообщения
  Future<void> addMessage(Message message) async {
    await _messagesBox.put(message.id, message); // Добавляем сообщение в хранилище

    // Обновляем информацию о последнем сообщении в чате
    final chat = _chatsBox.get(message.chatId);
    if (chat != null) {
      await _chatsBox.put(chat.id, Chat(
        id: chat.id,
        name: chat.name,
        lastName: chat.lastName,
        avatarUrl: chat.avatarUrl,
        lastMessageTime: message.timestamp, // Обновляем время последнего сообщения
        lastMessage: message.text.isEmpty ? 'Photo' : message.text, // Если текст пустой, указываем "Photo"
      ));
    }
    notifyListeners(); // Уведомляем слушателей об изменениях
  }

  // Метод для удаления чата и связанных с ним сообщений
  Future<void> deleteChat(String chatId) async {
    await _chatsBox.delete(chatId); // Удаляем чат из хранилища

    // Находим и удаляем все сообщения, связанные с этим чатом
    final messages = _messagesBox.values
        .where((m) => m.chatId == chatId) // Фильтруем сообщения по ID чата
        .map((m) => m.id) // Получаем ID сообщений
        .toList();
    await _messagesBox.deleteAll(messages); // Удаляем сообщения из хранилища
    notifyListeners(); // Уведомляем слушателей об изменениях
  }
}