import 'package:image_picker/image_picker.dart';

class PendingWardrobeImage {
  final XFile image;
  String detectedColor;
  String? detectedCategory;

  PendingWardrobeImage({
    required this.image,
    required this.detectedColor,
    this.detectedCategory,
  });
}