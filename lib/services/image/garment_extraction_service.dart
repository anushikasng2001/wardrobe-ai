import 'dart:io';

class GarmentExtractionService {
  const GarmentExtractionService._();

  /// Future implementation:
  ///
  /// 1. Detect garment mask
  /// 2. Remove background
  /// 3. Export transparent PNG
  ///
  /// Current implementation:
  /// Returns original image.
  static Future<File> extractGarment({
    required String imagePath,
    required String category,
    String? subCategory,
  }) async {
    return File(imagePath);
  }
}