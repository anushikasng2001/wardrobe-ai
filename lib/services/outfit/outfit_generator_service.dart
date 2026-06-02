import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';

class OutfitGeneratorService {

  static bool colorsMatch(
    String topColor,
    String bottomColor,
  ) {

    final goodMatches = {
      'Black': ['White', 'Grey', 'Beige', 'Blue', 'Black'],
      'White': ['Black', 'Blue', 'Grey', 'Beige'],
      'Blue': ['White', 'Black', 'Grey'],
      'Beige': ['Black', 'White', 'Brown'],
      'Grey': ['Black', 'White', 'Blue'],
    };

    return goodMatches[topColor]
            ?.contains(bottomColor) ??
        true;
  }

  static Outfit? generateOutfit({
    required List<WardrobeItem> items,
    required String occasion,
    required String weather,
  }) {

    final recentCutoff = DateTime.now().subtract(
      const Duration(days: 3),
    );

    final tops = items.where((i) {

      if (i.category != 'Top') return false;

      if (i.lastWorn == null) return true;

      return i.lastWorn!.isBefore(recentCutoff);

    }).toList();

    if (tops.isEmpty) {

      tops.addAll(
        items.where((i) => i.category == 'Top'),
      );
    }

    final bottoms = items.where((i) {

      if (i.category != 'Bottom') return false;

      if (i.lastWorn == null) return true;

      return i.lastWorn!.isBefore(recentCutoff);

    }).toList();

    if (bottoms.isEmpty) {

      bottoms.addAll(
        items.where((i) => i.category == 'Bottom'),
      );
    }

    final shoes = items.where((i) {

      if (i.category != 'Shoes') return false;

      if (i.lastWorn == null) return true;

      return i.lastWorn!.isBefore(recentCutoff);

    }).toList();

    if (shoes.isEmpty) {

      shoes.addAll(
        items.where((i) => i.category == 'Shoes'),
      );
    }

    final jackets = items.where((i) {

      if (i.category != 'Jacket') return false;

      if (i.lastWorn == null) return true;

      return i.lastWorn!.isBefore(recentCutoff);

    }).toList();

    if (jackets.isEmpty) {

      jackets.addAll(
        items.where((i) => i.category == 'Jacket'),
      );
    }

    if (tops.isEmpty || bottoms.isEmpty) {
      return null;
    }

    tops.shuffle();
    bottoms.shuffle();

    WardrobeItem? selectedTop;
    WardrobeItem? selectedBottom;

    for (final top in tops) {

      for (final bottom in bottoms) {

        if (
          colorsMatch(
            top.color,
            bottom.color,
          )
        ) {

          selectedTop = top;
          selectedBottom = bottom;

          break;
        }
      }
    }

    selectedTop ??= tops.first;
    selectedBottom ??= bottoms.first;

    final selected = <String>[
      selectedTop.imagePath,
      selectedBottom.imagePath,
    ];

    if (shoes.isNotEmpty) {

      shoes.shuffle();

      selected.add(shoes.first.imagePath);
    }

    if (
      weather == 'Cold' &&
      jackets.isNotEmpty
    ) {

      jackets.shuffle();

      selected.add(jackets.first.imagePath);
    }

    return Outfit(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      name: '$occasion Outfit',

      imagePaths: selected,

      occasion: occasion,

      weather: weather,

      createdAt: DateTime.now(),
    );
  }
}