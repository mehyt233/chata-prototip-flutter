import 'package:hive/hive.dart'; 
import 'chat.dart'; 

// Класс адаптера для модели Chat, реализующий TypeAdapter
class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 0; // Уникальный ID для этого адаптера (используется Hive)

  // Метод для чтения данных из базы данных
  @override
  Chat read(BinaryReader reader) {
    return Chat(
      id: reader.readString(), // Читаем ID чата
      name: reader.readString(), // Читаем имя пользователя
      avatarUrl: reader.readString(), // Читаем URL аватара
      lastMessageTime: reader.read() as DateTime, // Читаем время последнего сообщения
      lastMessage: reader.readString(), // Читаем текст последнего сообщения
      lastName: reader.readString(), // Читаем фамилию пользователя
    );
  }

  // Метод для записи данных в базу данных
  @override
  void write(BinaryWriter writer, Chat obj) {
    writer.writeString(obj.id); // Записываем ID чата
    writer.writeString(obj.name); // Записываем имя пользователя
    writer.writeString(obj.avatarUrl); // Записываем URL аватара
    writer.write(obj.lastMessageTime); // Записываем время последнего сообщения
    writer.writeString(obj.lastMessage); // Записываем текст последнего сообщения
    writer.writeString(obj.lastName); // Записываем фамилию пользователя
  }
}