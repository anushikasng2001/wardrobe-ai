import 'dart:convert';

class Outfit {
  final String id;
  final List<String> imagePaths;
  final String name;

  Outfit({
    required this.id,
    required this.imagePaths,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePaths': imagePaths,
      'name': name,
    };
  }

  factory Outfit.fromMap(Map<String, dynamic> map) {
    return Outfit(
      id: map['id'],
      imagePaths: List<String>.from(map['imagePaths']),
      name: map['name'],
    );
  }

  static String encode(List<Outfit> outfits) =>
      jsonEncode(outfits.map((o) => o.toMap()).toList());

  static List<Outfit> decode(String outfits) =>
      (jsonDecode(outfits) as List<dynamic>)
          .map((o) => Outfit.fromMap(o))
          .toList();

  Outfit copyWith({
    String? id,
    String? name,
    List<String>? imagePaths,
  }) {
    return Outfit(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }

}
