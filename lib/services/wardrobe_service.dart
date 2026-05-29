import 'package:wardrobe_ai/models/wardrobe_item.dart';

class WardrobeService {

  static const List<String> categories = [
    'All',
    'Top',
    'Bottom',
    'Dress',
    'Shoes',
    'Accessories',
    'Jacket',
  ];

  static List<WardrobeItem> getFilteredItems({
    required List<WardrobeItem> items,
    required String selectedCategory,
    required String searchQuery,
    required String sortOption,
  }) {

    List<WardrobeItem> filtered = List.from(items);

    final query = searchQuery.toLowerCase();

    if (selectedCategory != 'All') {
      filtered = filtered
          .where((i) => i.category == selectedCategory)
          .toList();
    }

    if (searchQuery.isNotEmpty) {

      filtered = filtered.where((item) {

        return item.category
                .toLowerCase()
                .contains(query) ||

            item.color
                .toLowerCase()
                .contains(query) ||

            item.tags.any(
              (tag) => tag
                  .toLowerCase()
                  .contains(query),
            );

      }).toList();
    }

    if (sortOption == 'Recent') {

      filtered.sort((a, b) {

        final aDate = a.lastWorn ?? DateTime(2000);
        final bDate = b.lastWorn ?? DateTime(2000);

        return bDate.compareTo(aDate);
      });
    }

    if (sortOption == 'Most Worn') {

      filtered.sort(
        (a, b) => b.wearCount.compareTo(a.wearCount),
      );
    }

    if (sortOption == 'Least Worn') {

      filtered.sort(
        (a, b) => a.wearCount.compareTo(b.wearCount),
      );
    }

    return filtered;
  }
}