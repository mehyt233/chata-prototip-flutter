import 'package:hive/hive.dart'; 

part 'chat.g.dart'; // Подключаем сгенерированный файл адаптера

// Класс Chat, аннотированный для работы с Hive
@HiveType(typeId: 0) // Уникальный ID типа данных в Hive
class Chat {
  @HiveField(0) // Поле ID (индекс 0)
  final String id;
  
  @HiveField(1) // Поле имени (индекс 1)
  final String name;
  
  @HiveField(2) // Поле URL аватара (индекс 2)
  final String avatarUrl;
  
  @HiveField(3) // Поле времени последнего сообщения (индекс 3)
  final DateTime lastMessageTime;
  
  @HiveField(4) // Поле текста последнего сообщения (индекс 4)
  final String lastMessage;
  
  @HiveField(5) // Поле фамилии (индекс 5)
  final String lastName;

  // Конструктор класса Chat
  Chat({
    required this.id, // Обязательное поле ID
    required this.name, // Обязательное поле имени
    required this.avatarUrl, // Обязательное поле URL аватара
    required this.lastMessageTime, // Обязательное поле времени последнего сообщения
    required this.lastMessage, // Обязательное поле текста последнего сообщения
    required this.lastName, // Обязательное поле фамилии
  });

  // Геттер для получения полного имени пользователя
  String get fullName => '$name $lastName'; // Возвращает имя и фамилию вместе
}