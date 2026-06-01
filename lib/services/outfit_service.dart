import '../models/outfit.dart';
import '../models/wardrobe_item.dart';

class OutfitService {
  static bool deleteItem({
    required WardrobeItem item,
    required List<WardrobeItem> items,
    required List<Outfit> outfits,
  }) {
    items.remove(item);

    for (int i = 0; i < outfits.length; i++) {
      final updatedPaths =
          List<String>.from(outfits[i].imagePaths)
            ..remove(item.imagePath);

      outfits[i] = outfits[i].copyWith(
        imagePaths: updatedPaths,
      );
    }

    final initialLength = outfits.length;

    outfits.removeWhere(
      (outfit) => outfit.imagePaths.isEmpty,
    );

    return outfits.length < initialLength;
  }
}