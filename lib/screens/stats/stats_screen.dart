import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/services/stats/stats_service.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_preview.dart';
import 'package:wardrobe_ai/widgets/stats/stats_card.dart';

class StatsScreen extends StatelessWidget {
  final List<WardrobeItem> items;
  final List<Outfit> outfits;

  const StatsScreen({
    super.key,
    required this.items,
    required this.outfits,
  });

  double get averageOutfitRating {
    final rated =
        outfits.where((o) => o.rating > 0).toList();

    if (rated.isEmpty) return 0;

    final total = rated.fold<double>(
      0,
      (sum, outfit) => sum + outfit.rating,
    );

    return total / rated.length;
  }

  int get fiveStarOutfits =>
      outfits.where((o) => o.rating == 5).length;

  List<Outfit> get topRatedOutfits {
    final rated =
        outfits.where((o) => o.rating > 0).toList();

    rated.sort(
      (a, b) => b.rating.compareTo(a.rating),
    );

    return rated.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stats =
        StatsService.calculateStats(items);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
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
                  value:
                      '${stats.neverWornItems}',
                  icon: Icons.hourglass_empty,
                ),
                StatsCard(
                  title: 'Avg Wears',
                  value: stats.averageWearCount
                      .toStringAsFixed(1),
                  icon: Icons.analytics,
                ),
                StatsCard(
                  title: 'Avg Rating',
                  value: averageOutfitRating.toStringAsFixed(1),
                  icon: Icons.star_rate,
                ),
                StatsCard(
                  title: '5-Star Outfits',
                  value: '$fiveStarOutfits',
                  icon: Icons.emoji_events,
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (topRatedOutfits.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Best Outfit Gallery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topRatedOutfits.length,
                      itemBuilder: (context, index) {
                        final outfit =
                            topRatedOutfits[index];

                        return Container(
                          width: 180,
                          margin: const EdgeInsets.only(
                            right: 12,
                          ),
                          child: Card(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: OutfitPreview(
                                      images: outfit.imagePaths,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.orange.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '#${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.orange,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        outfit.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: AppColors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            outfit.rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}