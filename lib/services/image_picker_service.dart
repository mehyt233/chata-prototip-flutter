import 'package:image_picker/image_picker.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'dart:io'; 

// Сервис для выбора и сохранения изображений
class ImagePickerService {
  static final ImagePicker _picker = ImagePicker(); // Экземпляр ImagePicker для выбора изображений

  // Метод для выбора изображения из галереи
  static Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // Выбираем изображение из галереи
    if (image == null) return null; // Если изображение не выбрано, возвращаем null

    // Сохраняем изображение в директорию приложения для постоянного хранения
    final appDir = await getApplicationDocumentsDirectory(); // Получаем директорию документов приложения
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg'; // Генерируем уникальное имя файла
    final savedImage = await File(image.path).copy('${appDir.path}/$fileName'); // Копируем файл в директорию приложения

    return savedImage.path; // Возвращаем путь к сохраненному изображению
  }
}