import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ClothingDetectorService {

  static Future<String?> detectClothing(
      String imagePath) async {

    final input =
        InputImage.fromFilePath(imagePath);

    final labeler =
        ImageLabeler(
      options:
          ImageLabelerOptions(
        confidenceThreshold: 0.6,
      ),
    );

    final labels =
        await labeler.processImage(
      input,
    );

    await labeler.close();

    for (final label in labels) {

      final text =
          label.label.toLowerCase();

      if (text.contains('shirt')) {
        return 'Shirt';
      }

      if (text.contains('t-shirt')) {
        return 'T-Shirt';
      }

      if (text.contains('pants')) {
        return 'Pants';
      }

      if (text.contains('jacket')) {
        return 'Jacket';
      }

      if (text.contains('dress')) {
        return 'Dress';
      }
    }

    return null;
  }
}