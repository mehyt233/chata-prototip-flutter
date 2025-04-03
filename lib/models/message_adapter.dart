import 'package:hive/hive.dart'; 
import 'message.dart'; 

// Класс адаптера для модели Message, реализующий TypeAdapter
class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 1; // Уникальный ID для этого адаптера (используется Hive)

  // Метод для чтения данных из базы данных
  @override
  Message read(BinaryReader reader) {
    return Message(
      id: reader.readString(), // Читаем ID сообщения
      chatId: reader.readString(), // Читаем ID чата
      content: reader.readString(), // Читаем содержимое сообщения
      text: reader.readString(), // Читаем текст сообщения
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()), // Читаем временную метку
      isMe: reader.readBool(), // Читаем флаг "сообщение от меня"
    );
  }

  // Метод для записи данных в базу данных
  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeString(obj.id); // Записываем ID сообщения
    writer.writeString(obj.chatId); // Записываем ID чата
    writer.writeString(obj.content); // Записываем содержимое сообщения
    writer.writeString(obj.text); // Записываем текст сообщения
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch); // Записываем временную метку
    writer.writeBool(obj.isMe); // Записываем флаг "сообщение от меня"
  }
}