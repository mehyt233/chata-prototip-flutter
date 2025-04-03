import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart'; 
import 'package:provider/provider.dart'; 
import '../models/message.dart'; 
import '../providers/chat_provider.dart'; 
import '../services/image_picker_service.dart'; 
import '../widgets/chat_bubble.dart'; 
import '../widgets/date_divider.dart'; 

// Экран чата, отображающий сообщения и позволяющий отправлять новые
class ChatScreen extends StatefulWidget {
  final String chatId; // ID текущего чата

  const ChatScreen({super.key, required this.chatId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController(); // Контроллер для текстового поля
  final ScrollController _scrollController = ScrollController(); // Контроллер для прокрутки списка

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(); // Прокручиваем список вниз при инициализации
    });
  }

  // Прокрутка списка в самый низ
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), // Длительность анимации
        curve: Curves.easeOut, // Кривая анимации
      );
    }
  }

  // Отправка текстового сообщения
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return; // Если текст пустой, не отправляем

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID сообщения
      chatId: widget.chatId, // ID чата
      content: _messageController.text, // Содержимое сообщения
      text: _messageController.text, // Текст сообщения
      timestamp: DateTime.now(), // Время отправки
      isMe: true, // Флаг "сообщение от меня"
    );

    _messageController.clear(); // Очищаем текстовое поле
    if (!mounted) return;
    await Provider.of<ChatProvider>(context, listen: false).addMessage(message); // Добавляем сообщение через провайдер
    if (!mounted) return;
    _scrollToBottom(); // Прокручиваем список вниз
  }

  // Отправка изображения
  Future<void> _sendImage() async {
    final imagePath = await ImagePickerService.pickImage(); // Выбираем изображение
    if (imagePath == null) return; // Если изображение не выбрано, выходим

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID сообщения
      chatId: widget.chatId, // ID чата
      content: '[Image]', // Содержимое (метка изображения)
      text: '[Image]', // Текст (метка изображения)
      timestamp: DateTime.now(), // Время отправки
      isMe: true, // Флаг "сообщение от меня"
      imagePath: imagePath, // Путь к изображению
    );

    if (!mounted) return;
    await Provider.of<ChatProvider>(context, listen: false).addMessage(message); // Добавляем сообщение через провайдер
    if (!mounted) return;
    _scrollToBottom(); // Прокручиваем список вниз
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context); // Получаем провайдер чатов
    final messages = chatProvider.getMessagesForChat(widget.chatId); // Сообщения для текущего чата
    final chat = chatProvider.chats.firstWhere((c) => c.id == widget.chatId); // Информация о текущем чате

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Кнопка "Назад"
          onPressed: () => Navigator.pop(context), // Возвращаемся на предыдущий экран
        ),
        title: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6, // Ограничение ширины заголовка
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: chat.avatarUrl.startsWith('http')
                    ? NetworkImage(chat.avatarUrl) // Загрузка изображения из сети
                    : AssetImage(chat.avatarUrl), // Загрузка изображения из локальных ресурсов
                radius: 20,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chat.name, // Имя пользователя
                      overflow: TextOverflow.ellipsis, // Обрезание текста при переполнении
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Онлайн', // Статус пользователя
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              DateFormat('HH:mm').format(DateTime.now()), // Текущее время
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Контроллер для прокрутки
              padding: const EdgeInsets.all(12),
              itemCount: messages.length, // Количество сообщений
              itemBuilder: (context, index) {
                final message = messages[index];
                final showDate = index == 0 || 
                    !_isSameDay(messages[index - 1].timestamp, message.timestamp); // Проверяем, нужно ли показывать дату
                
                return Column(
                  children: [
                    if (showDate)
                      DateDivider(date: message.timestamp), // Разделитель даты
                    ChatBubble(message: message), // Пузырек сообщения
                  ],
                );
              },
            ),
          ),
          _buildMessageInput(), // Поле ввода сообщения
        ],
      ),
    );
  }

  // Построение виджета для ввода сообщений
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file), // Иконка для прикрепления файла
            onPressed: _sendImage, // Отправка изображения
          ),
          Expanded(
            child: TextField(
              controller: _messageController, // Контроллер для текстового поля
              decoration: InputDecoration(
                hintText: 'Сообщение', // Подсказка в поле ввода
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // Закругленные углы
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send), // Иконка отправки
            onPressed: _sendMessage, // Отправка текстового сообщения
          ),
        ],
      ),
    );
  }

  // Проверка, относятся ли два сообщения к одному дню
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}