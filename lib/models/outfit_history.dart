class OutfitHistory {
  final String outfitId;
  final String outfitName;
  final List<String> imagePaths;
  final DateTime wornOn;

  const OutfitHistory({
    required this.outfitId,
    required this.outfitName,
    required this.imagePaths,
    required this.wornOn,
  });

  Map<String, dynamic> toMap() {

    return {
      'outfitId': outfitId,
      'outfitName': outfitName,
      'imagePaths': imagePaths,
      'wornOn': wornOn.toIso8601String(),
    };
  }

  factory OutfitHistory.fromMap(
    Map<String, dynamic> map,
  ) {

    final paths =
        List<String>.from(
          map['imagePaths'] ?? [],
        );

    return OutfitHistory(
      outfitId: map['outfitId'],
      outfitName: map['outfitName'],
      imagePaths: paths,
      wornOn: DateTime.parse(
        map['wornOn'],
      ),
    );
  }
}