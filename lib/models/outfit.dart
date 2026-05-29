import 'dart:convert';

class Outfit {
  final String id;
  final List<String> imagePaths;
  final String name;
  final bool isFavorite;
  final String occasion;
  final String weather;
  final int wearCount;
  final DateTime? lastWorn;
  final DateTime createdAt;
  final double rating;
  final List<String> tags;
  final String notes;

  const Outfit({
    required this.id,
    required this.imagePaths,
    required this.name,
    this.isFavorite = false,
    this.occasion = '',
    this.weather = '',
    this.wearCount = 0,
    this.lastWorn,
    required this.createdAt,
    this.rating = 0,
    this.tags = const [],
    this.notes = '',
  });

  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'imagePaths': imagePaths,
      'name': name,
      'isFavorite': isFavorite,
      'occasion': occasion,
      'weather': weather,
      'wearCount': wearCount,
      'lastWorn': lastWorn?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'rating': rating,
      'tags': tags,
      'notes': notes,
    };
  }

  factory Outfit.fromMap(Map<String, dynamic> map) {

    return Outfit(
      id: map['id'],
      imagePaths: List<String>.from(map['imagePaths']),
      name: map['name'],
      isFavorite: map['isFavorite'] ?? false,
      occasion: map['occasion'] ?? '',
      weather: map['weather'] ?? '',
      wearCount: map['wearCount'] ?? 0,
      lastWorn: map['lastWorn'] != null
          ? DateTime.parse(map['lastWorn'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      rating: (map['rating'] ?? 0).toDouble(),
      tags: List<String>.from(map['tags'] ?? []),
      notes: map['notes'] ?? '',
    );
  }

  static String encode(List<Outfit> outfits) {

    return jsonEncode(
      outfits.map((o) => o.toMap()).toList(),
    );
  }

  static List<Outfit> decode(String outfits) {

    return (jsonDecode(outfits) as List<dynamic>)
        .map((o) => Outfit.fromMap(o))
        .toList();
  }

  Outfit copyWith({
    String? id,
    List<String>? imagePaths,
    String? name,
    bool? isFavorite,
    String? occasion,
    String? weather,
    int? wearCount,
    DateTime? lastWorn,
    DateTime? createdAt,
    double? rating,
    List<String>? tags,
    String? notes,
  }) {

    return Outfit(
      id: id ?? this.id,
      imagePaths: imagePaths ?? this.imagePaths,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
      occasion: occasion ?? this.occasion,
      weather: weather ?? this.weather,
      wearCount: wearCount ?? this.wearCount,
      lastWorn: lastWorn ?? this.lastWorn,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }
}