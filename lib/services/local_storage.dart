import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat.dart'; 
import '../models/message.dart'; 

// Сервис для работы с локальным хранилищем через Hive
class LocalStorageService {
  static late Box<Chat> _chatsBox; // Хранилище чатов
  static late Box<Message> _messagesBox; // Хранилище сообщений

  // Инициализация хранилищ
  static Future<void> init() async {
    try {
      _chatsBox = await Hive.openBox<Chat>('chats'); // Открываем хранилище чатов
      _messagesBox = await Hive.openBox<Message>('messages'); // Открываем хранилище сообщений
    } catch (e) {
      print('Ошибка при открытии хранилищ: $e'); // Выводим ошибку в консоль
      rethrow; // Перебрасываем исключение для обработки выше
    }
  }

  // Закрытие хранилищ
  static Future<void> close() async {
    await _chatsBox.close(); // Закрываем хранилище чатов
    await _messagesBox.close(); // Закрываем хранилище сообщений
  }

  // Операции с чатами
  static Future<void> addChat(Chat chat) async {
    final chatsBox = Hive.box<Chat>('chats'); // Получаем хранилище чатов
    await chatsBox.put(chat.id, chat); // Добавляем или обновляем чат по его ID
  }

  static Future<void> deleteChat(String chatId) async {
    final chatsBox = Hive.box<Chat>('chats'); // Получаем хранилище чатов
    await chatsBox.delete(chatId); // Удаляем чат по его ID
    
    // Также удаляем связанные сообщения
    final messagesBox = Hive.box<Message>('messages'); // Получаем хранилище сообщений
    final messages = messagesBox.values.where((m) => m.chatId == chatId).toList(); // Находим сообщения для чата
    for (var message in messages) {
      await messagesBox.delete(message.id); // Удаляем каждое сообщение
    }
  }

  // Операции с сообщениями
  static Future<void> addMessage(Message message) async {
    final messagesBox = Hive.box<Message>('messages'); // Получаем хранилище сообщений
    await messagesBox.put(message.id, message); // Добавляем или обновляем сообщение по его ID
  }

  // Получение всех чатов
  static List<Chat> getAllChats() {
    final chatsBox = Hive.box<Chat>('chats'); // Получаем хранилище чатов
    return chatsBox.values.toList(); // Возвращаем все чаты как список
  }

  // Получение сообщений для конкретного чата
  static List<Message> getMessagesForChat(String chatId) {
    final messagesBox = Hive.box<Message>('messages'); // Получаем хранилище сообщений
    return messagesBox.values
        .where((message) => message.chatId == chatId) // Фильтруем сообщения по ID чата
        .toList(); // Возвращаем как список
  }
}