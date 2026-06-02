import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_ai/constants/storage_keys.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';

enum OutfitWearResult {
  success,
  noItemsFound,
  error,
}

class OutfitWearService {
  static Future<OutfitWearResult> markOutfitAsWorn(
    Outfit outfit,
  ) async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final data = prefs.getString(StorageKeys.wardrobeItems);

      if (data == null) {
        return OutfitWearResult.noItemsFound;
      }

      List<WardrobeItem> items =
          WardrobeItem.decode(data);

      bool updated = false;
      final now = DateTime.now();

      items = items.map((item) {
        if (outfit.imagePaths
            .contains(item.imagePath)) {
          updated = true;

          return item.copyWith(
            wearCount: item.wearCount + 1,
            lastWorn: now,
          );
        }

        return item;
      }).toList();

      if (!updated) {
        return OutfitWearResult.noItemsFound;
      }
      
      await prefs.setString(
        StorageKeys.wardrobeItems,
        WardrobeItem.encode(items),
      );

      return OutfitWearResult.success;
    } catch (_) {
      return OutfitWearResult.error;
    }
  }
}