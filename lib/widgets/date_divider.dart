import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования даты

// Виджет разделителя даты для отображения в списке сообщений
class DateDivider extends StatelessWidget {
  final DateTime date; // Дата, которую нужно отобразить

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Отступы сверху и снизу
      child: Row(
        children: [
          Expanded(child: Divider()), // Линия слева
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Отступы вокруг текста
            child: Text(
              DateFormat.yMMMd().format(date), // Форматирование даты (например, "Oct 15, 2023")
              style: TextStyle(color: Colors.grey), // Цвет текста
            ),
          ),
          Expanded(child: Divider()), // Линия справа
        ],
      ),
    );
  }
}