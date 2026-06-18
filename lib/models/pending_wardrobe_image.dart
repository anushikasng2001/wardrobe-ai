import 'package:image_picker/image_picker.dart';

class PendingWardrobeImage {
  final XFile image;
  final String detectedColor;
  final String detectedCategory;
  final String? detectedSubCategory;
  final double confidence;

  const PendingWardrobeImage({
    required this.image,
    required this.detectedColor,
    required this.detectedCategory,
    this.detectedSubCategory,
    required this.confidence
  });
}