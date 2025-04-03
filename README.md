
📱 Прототип мессенджера на Flutter

Приложение для обмена сообщениями, разработанное на Flutter, включает:

- Список чатов с сохранением данных в Hive
- Экран переписки
- Локальное хранение сообщений
- Возможность отправлять изображения

📸 Скриншоты

<div align="center">
  <img src="assets/screenshots/chat_list.png" width="30%" alt="Список чатов">
  <img src="assets/screenshots/chat_screen.png" width="30%" alt="Экран чата">
</div>

🏗 Структура проекта


lib/
├── main.dart              # Главная точка входа
│
├── models/                # Модели данных и адаптеры Hive
│   ├── chat.dart          # Модель чата
│   ├── chat.g.dart        # Автоматически сгенерированный адаптер для Chat
│   ├── message.dart       # Модель сообщения
│   └── message.g.dart     # Автоматически сгенерированный адаптер для Message
│
├── providers/             # Управление состоянием
│   └── chat_provider.dart # Основной контроллер состояния
│
├── screens/               # Экраны приложения
│   ├── chat_screen.dart     # Экран переписки
│   └── chats_list_screen.dart # Экран списка чатов
│
├── services/              # Бизнес-логика
│   ├── image_picker_service.dart # Обработка изображений
│   └── local_storage.dart       # Операции с Hive
│
└── widgets/               # Повторно используемые UI-компоненты
    ├── chat_bubble.dart     # Пузырь сообщения
    ├── chat_list_item.dart  # Элемент списка чатов
    └── date_divider.dart    # Разделитель дат


⚙️ Инструкции по настройке

1.Клонировать репозиторий:
```bash
git clone https://github.com/tu-usuario/flutter-messenger.git
```

Установить зависимости:
flutter pub get


Сгенерировать адаптеры Hive:
flutter pub run build_runner build


Запустить приложение*:
flutter run

Собрать APK:

flutter build apk --release


📦 Основные зависимости:
yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3               # Локальная база данных
  provider: ^6.1.4           # Управление состоянием
  image_picker: ^1.0.4       # Выбор изображений
  intl: ^0.18.1              # Интернационализация
  flutter_local_notifications: ^19.0.0 # Локальные уведомления

Зависимости для разработки:
yaml
dev_dependencies:
  build_runner: ^2.4.15      # Генерация кода
  hive_generator: ^2.0.1     # Генератор адаптеров


📝 Лицензия

Этот проект распространяется под лицензией MIT. Подробности см. в файле [LICENSE](LICENSE).

🔍 Дополнительные заметки

- Изображения хранятся локально с использованием Hive
- Интерфейс обновляется реактивно с помощью Provider
- Чаты сортируются по времени последнего сообщения
- Поддержка локальных уведомлений
