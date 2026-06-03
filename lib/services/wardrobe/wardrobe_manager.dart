import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/services/outfit/outfit_service.dart';
import 'package:wardrobe_ai/services/storage_service.dart';

class WardrobeData {
  final List<WardrobeItem> items;
  final List<Outfit> outfits;

  const WardrobeData({
    required this.items,
    required this.outfits,
  });
}

class WardrobeManager {

  WardrobeManager._();
  
  static Future<WardrobeData> loadData() async {
    final items =
        await StorageService.loadItems();

    final outfits =
        await StorageService.loadOutfits();

    return WardrobeData(
      items: items,
      outfits: outfits,
    );
  }

  static Future<void> saveData({
    required List<WardrobeItem> items,
    required List<Outfit> outfits,
  }) async {
    await StorageService.saveItems(items);
    await StorageService.saveOutfits(outfits);
  }

  static bool deleteItem({
    required WardrobeItem item,
    required List<WardrobeItem> items,
    required List<Outfit> outfits,
  }) {
    return OutfitService.deleteItem(
      item: item,
      items: items,
      outfits: outfits,
    );
  }

  static bool updateItem({
    required List<WardrobeItem> items,
    required WardrobeItem item,
    required String category,
    required String color,
  }) {
    final index =
        items.indexWhere((i) => i.id == item.id);

    if (index == -1) return false;

    items[index] = item.copyWith(
      category: category,
      color: color,
    );

    return true;
  }

  static void addOutfit({
    required List<Outfit> outfits,
    required Outfit outfit,
  }) {
    outfits.add(outfit);
  }

  static void addItems({
    required List<WardrobeItem> items,
    required List<String> imagePaths,
    required String category,
    required String color,
  }) {
    for (final path in imagePaths) {
      final now = DateTime.now();

      items.add(
        WardrobeItem(
          id: '${now.microsecondsSinceEpoch}_$path',
          imagePath: path,
          category: category,
          color: color,
          tags: [],
          createdAt: now,
        ),
      );
    }
  }

  static bool toggleFavorite({
    required List<WardrobeItem> items,
    required WardrobeItem item,
  }) {
    final index =
        items.indexWhere((i) => i.id == item.id);

    if (index == -1) return false;

    items[index] = items[index].copyWith(
      isFavorite: !items[index].isFavorite,
    );

    return true;
  }
}