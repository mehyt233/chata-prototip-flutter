import 'package:hive/hive.dart'; 

part 'message.g.dart'; // Подключаем сгенерированный файл адаптера

// Класс Message, аннотированный для работы с Hive
@HiveType(typeId: 1) // Уникальный ID типа данных в Hive
class Message {
  @HiveField(0) // Поле ID (индекс 0)
  final String id;
  
  @HiveField(1) // Поле ID чата (индекс 1)
  final String chatId;
  
  @HiveField(2) // Поле содержимого сообщения (индекс 2)
  final String content;
  
  @HiveField(3) // Поле временной метки (индекс 3)
  final DateTime timestamp;
  
  @HiveField(4) // Поле флага "сообщение от меня" (индекс 4)
  final bool isMe;
  
  @HiveField(5) // Поле пути к изображению (индекс 5, может быть null)
  final String? imagePath;
  
  @HiveField(6) // Поле текста сообщения (индекс 6)
  final String text;

  // Конструктор класса Message
  Message({
    required this.id, // Обязательное поле ID
    required this.chatId, // Обязательное поле ID чата
    required this.content, // Обязательное поле содержимого сообщения
    required this.timestamp, // Обязательное поле временной метки
    required this.isMe, // Обязательное поле флага "сообщение от меня"
    this.imagePath, // Необязательное поле пути к изображению
    required this.text, // Обязательное поле текста сообщения
  });
}