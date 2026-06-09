import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_preview.dart';

enum OutfitGalleryType {
  rating,
  wears,
}

class OutfitGallerySection extends StatelessWidget {
  final String title;
  final List<Outfit> outfits;
  final OutfitGalleryType type;

  const OutfitGallerySection({
    super.key,
    required this.title,
    required this.outfits,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final outfit = outfits[index];

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
                        padding:
                            const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _badgeColor()
                                    .withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#${index + 1}',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  color: _badgeColor(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              outfit.name,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Row(
                              children: [
                                Icon(
                                  _metricIcon(),
                                  size: 16,
                                  color: _badgeColor(),
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  _metricText(outfit),
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
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
    );
  }

  Color _badgeColor() {
    switch (type) {
      case OutfitGalleryType.rating:
        return AppColors.orange;

      case OutfitGalleryType.wears:
        return AppColors.blue;
    }
  }

  IconData _metricIcon() {
    switch (type) {
      case OutfitGalleryType.rating:
        return Icons.star;

      case OutfitGalleryType.wears:
        return Icons.repeat;
    }
  }

  String _metricText(Outfit outfit) {
    switch (type) {
      case OutfitGalleryType.rating:
        return outfit.rating.toStringAsFixed(1);

      case OutfitGalleryType.wears:
        return '${outfit.wearCount} wears';
    }
  }
}