import 'package:flutter/material.dart';
import '../models/chat.dart'; 

// Виджет элемента чата для отображения в списке чатов
class ChatItem extends StatelessWidget {
  final Chat chat; // Данные чата
  final VoidCallback onTap; // Колбэк для обработки нажатия на элемент

  const ChatItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(chat.name); // Получаем инициалы из имени

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getAvatarColor(chat.id), // Цвет фона аватара
        backgroundImage: chat.avatarUrl.startsWith('http')
            ? NetworkImage(chat.avatarUrl) // Загрузка изображения из сети
            : chat.avatarUrl.startsWith('assets/')
                ? AssetImage(chat.avatarUrl) // Загрузка изображения из локальных ресурсов
                : null, // Если URL не подходит, аватар не имеет фонового изображения
        child: chat.avatarUrl.startsWith('http') || chat.avatarUrl.startsWith('assets/')
            ? null // Если есть изображение, текст не отображается
            : Text(initials, style: TextStyle(color: Colors.white)), // Отображение инициалов
      ),
      title: Text(chat.name), // Имя пользователя
      subtitle: Text(
        chat.lastMessage, // Последнее сообщение
        maxLines: 1, // Ограничение на одну строку
        overflow: TextOverflow.ellipsis, // Обрезание текста с многоточием
      ),
      trailing: Text(
        '${chat.lastMessageTime.hour}:${chat.lastMessageTime.minute.toString().padLeft(2, '0')}', // Время последнего сообщения
        style: TextStyle(color: Colors.grey), // Цвет текста времени
      ),
      onTap: onTap, // Обработчик нажатия на элемент
    );
  }
}

// Получение инициалов из полного имени
String _getInitials(String fullName) {
    final names = fullName.split(' '); // Разделяем имя по пробелам
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'; // Берем первые буквы имени и фамилии
    } else if (fullName.isNotEmpty) {
      return fullName[0]; // Если только одно слово, берем первую букву
    }
    return ''; // Если имя пустое, возвращаем пустую строку
  }

// Получение цвета аватара на основе ID чата
Color _getAvatarColor(String id) {
    final colors = [
      Colors.blue, // Синий
      Colors.red, // Красный
      Colors.green, // Зеленый
      Colors.orange, // Оранжевый
      Colors.purple, // Фиолетовый
    ];
    return colors[id.hashCode % colors.length]; // Выбираем цвет по хешу ID
  }