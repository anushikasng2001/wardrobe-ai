class DetectedClothingItem {

  final String category;
  final String? subcategory;
  final String color;

  const DetectedClothingItem({
    required this.category,
    this.subcategory,
    required this.color,
  });
}