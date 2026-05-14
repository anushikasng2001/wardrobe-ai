import 'dart:convert';

class WardrobeItem {
  final String imagePath;
  final String category;

  WardrobeItem({
    required this.imagePath,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'category': category,
    };
  }

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      imagePath: json['imagePath'],
      category: json['category'],
    );
  }

  static String encode(List<WardrobeItem> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<WardrobeItem> decode(String items) =>
      (jsonDecode(items) as List<dynamic>)
          .map((e) => WardrobeItem.fromJson(e))
          .toList();
}
