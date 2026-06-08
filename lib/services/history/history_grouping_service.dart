import 'package:wardrobe_ai/models/outfit_history.dart';

class HistoryGroupingService {

  static Map<String, List<OutfitHistory>>
      groupHistory(
    List<OutfitHistory> history,
  ) {

    final now = DateTime.now();

    final grouped =
        <String, List<OutfitHistory>>{};

    for (final entry in history) {

      final date = entry.wornOn;

      late String section;

      if (_isSameDay(date, now)) {

        section = 'Today';

      } else if (_isSameDay(
        date,
        now.subtract(
          const Duration(days: 1),
        ),
      )) {

        section = 'Yesterday';

      } else {

        section = 'Older';
      }

      grouped.putIfAbsent(
        section,
        () => [],
      );

      grouped[section]!.add(entry);
    }

    return grouped;
  }

  static bool _isSameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}