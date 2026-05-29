import 'package:shared_preferences/shared_preferences.dart';

import '../models/outfit.dart';
import '../models/wardrobe_item.dart';

class StorageService {

  static Future<List<WardrobeItem>> loadItems() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('wardrobe_items');

    if (data == null) {
      return [];
    }

    return WardrobeItem.decode(data);
  }

  static Future<List<Outfit>> loadOutfits() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('outfits');

    if (data == null) {
      return [];
    }

    return Outfit.decode(data);
  }

  static Future<void> saveItems(
    List<WardrobeItem> items,
  ) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'wardrobe_items',
      WardrobeItem.encode(items),
    );
  }

  static Future<void> saveOutfits(
    List<Outfit> outfits,
  ) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'outfits',
      Outfit.encode(outfits),
    );
  }
}