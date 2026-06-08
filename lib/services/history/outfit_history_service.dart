import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/models/outfit_history.dart';

class OutfitHistoryService {

  static void addHistoryEntry({
    required List<OutfitHistory> history,
    required Outfit outfit,
  }) {

    history.insert(
      0,
      OutfitHistory(
        outfitId: outfit.id,
        outfitName: outfit.name,
        imagePaths: outfit.imagePaths,
        wornOn: DateTime.now(),
      ),
    );
  }
}