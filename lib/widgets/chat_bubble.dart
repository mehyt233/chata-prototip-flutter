import 'dart:io'; 
import 'package:flutter/material.dart'; 
import '../models/message.dart'; 

// Виджет пузырька сообщения для отображения в чате
class ChatBubble extends StatelessWidget {
  final Message message; // Сообщение, которое нужно отобразить

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe 
          ? Alignment.centerRight // Выравнивание вправо для своих сообщений
          : Alignment.centerLeft, // Выравнивание влево для сообщений собеседника
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Отступы вокруг пузырька
        padding: EdgeInsets.all(12), // Внутренние отступы текста или изображения
        decoration: BoxDecoration(
          color: message.isMe 
              ? Theme.of(context).primaryColor // Цвет фона для своих сообщений
              : Colors.grey[300], // Цвет фона для сообщений собеседника
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), // Закругление верхнего левого угла
            topRight: Radius.circular(12), // Закругление верхнего правого угла
            bottomLeft: message.isMe ? Radius.circular(12) : Radius.circular(0), // Закругление нижнего левого угла
            bottomRight: message.isMe ? Radius.circular(0) : Radius.circular(12), // Закругление нижнего правого угла
          ),
        ),
        child: message.imagePath != null
            ? Image.file(
                File(message.imagePath!), // Отображение изображения из файла
                width: 200, // Ширина изображения
                height: 200, // Высота изображения
                fit: BoxFit.cover, // Режим масштабирования изображения
              )
            : Text(
                message.text, // Отображение текста сообщения
                style: TextStyle(
                  color: message.isMe ? Colors.white : Colors.black, // Цвет текста
                ),
              ),
      ),
    );
  }
}