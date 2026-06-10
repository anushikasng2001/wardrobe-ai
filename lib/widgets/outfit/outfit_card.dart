import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_preview.dart';

class OutfitCard extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onLongPress;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.onTap,
    required this.onFavorite,
    required this.onLongPress,
  });

  String _ratingText(double rating) {
    if (rating == 0) return 'New';
    return rating.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: outfit.rating >= 4
                ? Colors.amber
                : Colors.transparent,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: OutfitPreview(
                images: outfit.imagePaths,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          outfit.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: outfit.rating > 0
                                  ? Colors.amber
                                  : Colors.grey,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              _ratingText(outfit.rating),
                              style: TextStyle(
                                fontSize: 12,
                                color: outfit.rating > 0
                                    ? Colors.amber.shade800
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      outfit.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: outfit.isFavorite
                          ? AppColors.red
                          : AppColors.grey,
                    ),
                    onPressed: onFavorite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}