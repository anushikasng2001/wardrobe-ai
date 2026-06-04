import 'package:wardrobe_ai/models/stats_model.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';


class StatsService {

  static WardrobeStats calculateStats(
    List<WardrobeItem> items,
  ) {

    final totalItems = items.length;

    final favoriteItems =
        items.where(
          (i) => i.isFavorite,
        ).length;

    final totalWearCount =
        items.fold(
          0,
          (sum, item) =>
              sum + item.wearCount,
        );

    final categoryCounts =
        <String, int>{};

    for (final item in items) {
      categoryCounts[item.category] = (categoryCounts[item.category] ?? 0) + 1;
    }

    final neverWornItems =
        items.where(
          (i) => i.wearCount == 0,
        ).length;

    final averageWearCount =
        totalItems == 0
            ? 0.0
            : totalWearCount / totalItems;

    String topCategory = 'N/A';

    if (categoryCounts.isNotEmpty) {
      topCategory =
          categoryCounts.entries
              .reduce(
                (a, b) =>
                    a.value > b.value
                        ? a
                        : b,
              )
              .key;
    }

    return WardrobeStats(
      totalItems: totalItems,
      favoriteItems: favoriteItems,
      totalWearCount: totalWearCount,
      topCategory: topCategory,
      neverWornItems: neverWornItems,
      averageWearCount: averageWearCount,
    );
  }

  static WardrobeItem? getMostWornItem(
    List<WardrobeItem> items,
  ) {
    if (items.isEmpty) return null;

    return items.reduce(
      (a, b) =>
          a.wearCount > b.wearCount
              ? a
              : b,
    );
  }

  static WardrobeItem? getLeastWornItem(
    List<WardrobeItem> items,
  ) {
    if (items.isEmpty) return null;

    return items.reduce(
      (a, b) =>
          a.wearCount < b.wearCount
              ? a
              : b,
    );
  }
}