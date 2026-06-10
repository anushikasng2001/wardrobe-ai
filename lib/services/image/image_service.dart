import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker =
      ImagePicker();

  static Future<File?> pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image == null) return null;

    return File(image.path);
  }

  static Future<File?> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) return null;

    return File(image.path);
  }

  static Future<List<XFile>> pickMultipleFromGallery() async {
    final images = await _picker.pickMultiImage(
      imageQuality: 90,
    );

    return images;
  }
}