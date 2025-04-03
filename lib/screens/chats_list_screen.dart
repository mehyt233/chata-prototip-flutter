import 'package:chat/widgets/chat_list_item.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import '../models/chat.dart'; 
import '../providers/chat_provider.dart'; 
import 'chat_screen.dart'; 

// Экран со списком чатов
class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  ChatsListScreenState createState() => ChatsListScreenState();
}

class ChatsListScreenState extends State<ChatsListScreen> {
  final TextEditingController _searchController = TextEditingController(); // Контроллер для поля поиска
  String _searchQuery = ''; // Текущий запрос поиска

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context); // Получаем провайдер чатов
    List<Chat> chats = _filterChats(chatProvider.chats); // Фильтруем чаты по запросу

    return Scaffold(
      appBar: _buildAppBar(), // Построение панели приложения
      body: _buildChatList(context, chats, chatProvider), // Список чатов
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add), // Кнопка добавления нового чата
        onPressed: () => _showAddChatDialog(context, chatProvider), // Открываем диалог создания чата
      ),
    );
  }

  // Фильтрация чатов по запросу
  List<Chat> _filterChats(List<Chat> chats) {
    return _searchQuery.isEmpty
        ? chats // Если запрос пустой, возвращаем все чаты
        : chats.where((chat) => 
            chat.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList(); // Фильтруем по имени
  }

  // Построение панели приложения
  AppBar _buildAppBar() {
    return AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Тест', style: TextStyle(fontSize: 28)), // Заголовок
          Text('Поиск в чате', style: TextStyle(fontSize: 11)), // Подзаголовок
        ],
      ),
    );
  }

  // Построение списка чатов
  Widget _buildChatList(BuildContext context, List<Chat> chats, ChatProvider chatProvider) {
    return Column(
      children: [
        _buildSearchField(), // Поле поиска
        Expanded(
          child: ListView.builder(
            itemCount: chats.length, // Количество чатов
            itemBuilder: (context, index) => _buildChatItem(context, chats[index], chatProvider), // Элемент чата
          ),
        ),
      ],
    );
  }

  // Построение поля поиска
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController, // Контроллер для текстового поля
        decoration: InputDecoration(
          hintText: 'поиск чата....', // Подсказка
          prefixIcon: const Icon(Icons.search), // Иконка поиска
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Закругленные углы
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) => setState(() => _searchQuery = value), // Обновляем запрос при изменении текста
      ),
    );
  }

  // Построение элемента чата
  Widget _buildChatItem(BuildContext context, Chat chat, ChatProvider chatProvider) {
    return Dismissible(
      key: Key(chat.id), // Уникальный ключ для элемента
      background: Container(color: Colors.red), // Фон при удалении
      confirmDismiss: (direction) => _confirmDeleteDialog(context), // Подтверждение удаления
      onDismissed: (direction) => _deleteChat(context, chatProvider, chat.id), // Действие при удалении
      child: ChatItem( // Используем виджет элемента чата
        chat: chat, // Данные чата
        onTap: () => _navigateToChat(context, chat.id), // Переход к экрану чата
      ),
    );
  }

  // Диалог подтверждения удаления чата
  Future<bool?> _confirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чат'), // Заголовок
        content: const Text('Вы уверены, что хотите удалить этот чат?'), // Сообщение
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Отмена
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Подтверждение
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Удаление чата
  void _deleteChat(BuildContext context, ChatProvider chatProvider, String chatId) {
    chatProvider.deleteChat(chatId); // Удаляем чат через провайдер
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Чат удален')), // Показываем уведомление
    );
  }

  // Переход к экрану чата
  void _navigateToChat(BuildContext context, String chatId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatId: chatId), // Переход на экран чата
      ),
    );
  }

  // Диалог добавления нового чата
  void _showAddChatDialog(BuildContext context, ChatProvider chatProvider) {
    final nameController = TextEditingController(); // Контроллер для имени
    final lastNameController = TextEditingController(); // Контроллер для фамилии

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый чат'), // Заголовок
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController, // Поле для имени
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: lastNameController, // Поле для фамилии
              decoration: const InputDecoration(labelText: 'Фамилия'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Отмена
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => _createNewChat(
              context, 
              chatProvider, 
              nameController.text, 
              lastNameController.text
            ), // Создание чата
            child: const Text('Создавать'),
          ),
        ],
      ),
    );
  }

  // Создание нового чата
  void _createNewChat(
    BuildContext context,
    ChatProvider chatProvider,
    String name,
    String lastName,
  ) {
    if (name.isEmpty) return; // Если имя пустое, выходим

    final fullName = lastName.isNotEmpty ? '$name $lastName' : name; // Полное имя
    final initials = _getInitials(name, lastName); // Инициалы
    final avatarUrl = 'https://ui-avatars.com/api/?name=$initials&background=random'; // URL аватара

    final newChat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID
      name: fullName, // Полное имя
      lastName: lastName, // Фамилия
      avatarUrl: avatarUrl, // URL аватара
      lastMessageTime: DateTime.now(), // Время последнего сообщения
      lastMessage: 'Чат создан', // Текст последнего сообщения
    );

    chatProvider.addChat(newChat); // Добавляем чат через провайдер
    Navigator.of(context).pop(); // Закрываем диалог
  }

  // Получение инициалов из имени и фамилии
  String _getInitials(String name, String lastName) {
    final nameInitial = name.isNotEmpty ? name[0] : ''; // Первая буква имени
    final lastNameInitial = lastName.isNotEmpty ? lastName[0] : ''; // Первая буква фамилии
    return '$nameInitial$lastNameInitial'; // Объединяем инициалы
  }
}