import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageService {
  static final ImagePicker _picker =
      ImagePicker();

  static Future<File?> pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image == null) return null;

    return _cropImage(image.path);
  }

  static Future<File?> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) return null;

    return _cropImage(image.path);
  }

  static Future<File?> _cropImage(
    String path,
  ) async {
    final cropped =
        await ImageCropper().cropImage(
      sourcePath: path,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          lockAspectRatio: false,
        ),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }
}