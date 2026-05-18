import 'dart:convert';

class WardrobeItem {
  final String imagePath;
  final String category;
  final String color;
  final List<String> tags;

  WardrobeItem({
    required this.imagePath,
    required this.category,
    required this.color,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'category': category,
      'color': color,
      'tags': tags,
    };
  }

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      imagePath: json['imagePath'],
      category: json['category'],
      color: json['color'] ?? 'Black',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  static String encode(List<WardrobeItem> items) =>
      jsonEncode(
        items.map((e) => e.toJson()).toList(),
      );

  static List<WardrobeItem> decode(String items) =>
      (jsonDecode(items) as List<dynamic>)
          .map((e) => WardrobeItem.fromJson(e))
          .toList();

  // Helpful for future editing support
  WardrobeItem copyWith({
    String? imagePath,
    String? category,
    String? color,
    List<String>? tags,
  }) {
    return WardrobeItem(
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      color: color ?? this.color,
      tags: tags ?? this.tags,
    );
  }
}