import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Для kDebugMode
import 'package:provider/provider.dart'; // Для управления состоянием
import 'package:hive_flutter/hive_flutter.dart'; // Локальное хранилище
import 'models/chat.dart'; // Модель чата
import 'models/message.dart'; // Модель сообщения
import 'providers/chat_provider.dart'; // Провайдер состояния
import 'screens/chats_list_screen.dart'; // Экран списка чатов
import 'screens/chat_screen.dart'; // Экран чата

void main() async {
  // 1. Инициализация связующего слоя Flutter
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Настройка Hive - локальной NoSQL базы данных
    // Указываем папку для хранения данных
    await Hive.initFlutter('hive_data');
    
    // 3. Регистрация адаптеров для моделей
    // Проверяем, чтобы не регистрировать повторно
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatAdapter()); // Адаптер для чатов
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MessageAdapter()); // Адаптер для сообщений
    }

    // 4. Открытие "коробок" (таблиц) в Hive
    await Hive.openBox<Chat>('chats'); // Для хранения чатов
    await Hive.openBox<Message>('messages'); // Для хранения сообщений

    // 5. Загрузка тестовых данных, если чатов нет
    if (Hive.box<Chat>('chats').isEmpty) {
      await _addDemoData();
    }

    // 6. Запуск приложения с провайдерами
    runApp(
      MultiProvider(
        providers: [
          // Главный провайдер для управления чатами
          ChangeNotifierProvider(create: (_) => ChatProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    // 7. Обработка ошибок инициализации
    if (kDebugMode) {
      // Логирование только в режиме разработки
      debugPrint('Ошибка инициализации: $e\n$stack');
    }
    
    // 8. При критической ошибке:
    // - Закрываем Hive
    // - Удаляем данные
    // - Перезапускаем приложение
    await Hive.close();
    await Hive.deleteBoxFromDisk('chats');
    await Hive.deleteBoxFromDisk('messages');
    main();
  }
}

// Метод для загрузки тестовых данных
Future<void> _addDemoData() async {
  // Получаем ссылки на "коробки"
  final chatsBox = Hive.box<Chat>('chats');
  final messagesBox = Hive.box<Message>('messages');

  // 1. Создаем тестовые чаты
  final demoChats = [
    Chat(
      id: '1',
      name: 'John',
      lastName: 'Doe',
      avatarUrl: 'assets/images/john_doe.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      lastMessage: 'Hey, how are you?',
    ),
    Chat(
      id: '2',
      name: 'Jane',
      lastName: 'Smith',
      avatarUrl: 'assets/images/jane_smith.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      lastMessage: 'Meeting at 3pm',
    ),
  ];

  // 2. Сохраняем чаты в Hive
  for (var chat in demoChats) {
    await chatsBox.put(chat.id, chat); // Ключ - id чата, значение - объект чата
  }

  // 3. Создаем тестовые сообщения
  final demoMessages = [
    Message(
      id: '1',
      chatId: '1', // Принадлежит первому чату
      text: 'Hey there!',
      content: 'Hey there!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isMe: false, // Сообщение от собеседника
    ),
    Message(
      id: '2',
      chatId: '1', // Принадлежит первому чату
      text: 'How are you doing?',
      content: 'How are you doing?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isMe: true, // Сообщение от текущего пользователя
    ),
  ];

  // 4. Сохраняем сообщения в Hive
  for (var message in demoMessages) {
    await messagesBox.put(message.id, message);
  }
}

// Главный виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Убираем баннер debug
      title: 'Flutter Messenger',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Основной цвет
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Стартовый экран - список чатов
      home: const ChatsListScreen(),
      routes: {
        // Маршрут для экрана чата
        '/chat': (context) {
          // Получаем ID чата из аргументов
          final chatId = ModalRoute.of(context)!.settings.arguments as String;
          return ChatScreen(chatId: chatId);
        },
      },
    );
  }
}