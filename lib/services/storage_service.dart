import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_ai/constants/storage_keys.dart';
import 'package:wardrobe_ai/models/outfit_history.dart';

import '../models/outfit.dart';
import '../models/wardrobe_item.dart';
import 'dart:convert';

class StorageService {

  static const String historyKey = 'outfit_history';

  static Future<List<WardrobeItem>> loadItems() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(StorageKeys.wardrobeItems);

    if (data == null) {
      return [];
    }

    return WardrobeItem.decode(data);
  }

  static Future<List<Outfit>> loadOutfits() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(StorageKeys.outfits);

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
      StorageKeys.wardrobeItems,
      WardrobeItem.encode(items),
    );
  }

  static Future<void> saveOutfits(
    List<Outfit> outfits,
  ) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      StorageKeys.outfits,
      Outfit.encode(outfits),
    );
  }

  static Future<void> saveHistory(
    List<OutfitHistory> history,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final json =
        jsonEncode(
          history
              .map((e) => e.toMap())
              .toList(),
        );

    await prefs.setString(
      historyKey,
      json,
    );
  }

  static Future<List<OutfitHistory>>
      loadHistory() async {

    final prefs =
        await SharedPreferences.getInstance();

    final json =
        prefs.getString(historyKey);

    if (json == null) {
      return [];
    }

    final decoded =
        jsonDecode(json) as List<dynamic>;

    return decoded
        .map(
          (e) => OutfitHistory.fromMap(
            e,
          ),
        )
        .toList();
  }
}