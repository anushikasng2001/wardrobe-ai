import 'package:flutter/material.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/services/stats/stats_service.dart';
import 'package:wardrobe_ai/widgets/stats/stats_card.dart';

class StatsScreen extends StatelessWidget {
  final List<WardrobeItem> items;

  const StatsScreen({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final stats =
        StatsService.calculateStats(items);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [

            StatsCard(
              title: 'Items',
              value: '${stats.totalItems}',
              icon: Icons.checkroom,
            ),

            StatsCard(
              title: 'Favorites',
              value: '${stats.favoriteItems}',
              icon: Icons.favorite,
            ),

            StatsCard(
              title: 'Total Wears',
              value: '${stats.totalWearCount}',
              icon: Icons.repeat,
            ),

            StatsCard(
              title: 'Top Category',
              value: stats.topCategory,
              icon: Icons.star,
            ),

            StatsCard(
              title: 'Never Worn',
              value: '${stats.neverWornItems}',
              icon: Icons.hourglass_empty,
            ),

            StatsCard(
              title: 'Avg Wears',
              value:
                  stats.averageWearCount
                      .toStringAsFixed(1),
              icon: Icons.analytics,
            ),
          ],
        ),
      ),
    );
  }
}