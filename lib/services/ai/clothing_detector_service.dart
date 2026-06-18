import 'package:flutter/foundation.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ClothingDetectorService {
  static Future<String> detectCategory(
    String imagePath,
  ) async {
    final input =
        InputImage.fromFilePath(imagePath);

    final labeler = ImageLabeler(
      options: ImageLabelerOptions(
        confidenceThreshold: 0.5,
      ),
    );

    final labels =
        await labeler.processImage(input);

    await labeler.close();

    for (final label in labels) {
      final text =
          label.label.toLowerCase();

      debugPrint(
        '${label.label} (${label.confidence})',
      );

      if (text.contains('dress')) {
        return 'Dress';
      }

      if (text.contains('shoe') ||
          text.contains('sneaker')) {
        return 'Shoes';
      }

      if (text.contains('jacket') ||
          text.contains('coat')) {
        return 'Outerwear';
      }

      if (text.contains('shirt') ||
          text.contains('t-shirt') ||
          text.contains('top')) {
        return 'Top';
      }

      if (text.contains('pants') ||
          text.contains('jeans') ||
          text.contains('trouser')) {
        return 'Bottom';
      }
    }

    return 'Unknown';
  }
}