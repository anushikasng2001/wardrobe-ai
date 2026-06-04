class WardrobeStats {
  final int totalItems;
  final int favoriteItems;
  final int totalWearCount;
  final String topCategory;

  final int neverWornItems;
  final double averageWearCount;

  const WardrobeStats({
    required this.totalItems,
    required this.favoriteItems,
    required this.totalWearCount,
    required this.topCategory,
    required this.neverWornItems,
    required this.averageWearCount,
  });
}