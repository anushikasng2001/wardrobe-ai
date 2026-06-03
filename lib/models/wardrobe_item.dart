import 'dart:convert';

class WardrobeItem {
  final String id;
  final String imagePath;
  final String category;
  final String color;
  final List<String> tags;
  final int wearCount;
  final DateTime? lastWorn;
  final bool isFavorite;
  final double rating;
  final DateTime createdAt;
  final String season;
  final String brand;
  final String notes;

  const WardrobeItem({
    required this.id,
    required this.imagePath,
    required this.category,
    required this.color,
    required this.tags,

    this.wearCount = 0,
    this.lastWorn,
    this.isFavorite = false,
    this.rating = 0,
    required this.createdAt,
    this.season = '',
    this.brand = '',
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'category': category,
      'color': color,
      'tags': tags,
      'wearCount': wearCount,
      'lastWorn': lastWorn?.toIso8601String(),
      'isFavorite': isFavorite,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'season': season,
      'brand': brand,
      'notes': notes,
    };
  }

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      category: json['category'] as String,
      color: json['color'] ?? 'Black',
      tags: List<String>.from(json['tags'] ?? []),
      wearCount: json['wearCount'] ?? 0,
      lastWorn: json['lastWorn'] != null
          ? DateTime.parse(json['lastWorn'])
          : null,
      isFavorite: json['isFavorite'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      season: json['season'] ?? '',
      brand: json['brand'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WardrobeItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  static String encode(List<WardrobeItem> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  static List<WardrobeItem> decode(String items) {
    return (jsonDecode(items) as List<dynamic>)
        .map((e) => WardrobeItem.fromJson(e))
        .toList();
  }

  WardrobeItem copyWith({
    String? id,
    String? imagePath,
    String? category,
    String? color,
    List<String>? tags,
    int? wearCount,
    DateTime? lastWorn,
    bool? isFavorite,
    double? rating,
    DateTime? createdAt,
    String? season,
    String? brand,
    String? notes,
  }) {
    return WardrobeItem(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      color: color ?? this.color,
      tags: tags ?? this.tags,
      wearCount: wearCount ?? this.wearCount,
      lastWorn: lastWorn ?? this.lastWorn,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      season: season ?? this.season,
      brand: brand ?? this.brand,
      notes: notes ?? this.notes,
    );
  }
}
