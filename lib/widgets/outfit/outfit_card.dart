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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
                    child: Text(
                      outfit.name,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      outfit.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: outfit.isFavorite
                          ? AppColors.favorite
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