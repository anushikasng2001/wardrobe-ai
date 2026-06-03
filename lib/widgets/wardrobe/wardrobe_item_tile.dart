import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

class WardrobeItemTile extends StatelessWidget {
  final WardrobeItem item;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteToggle;

  const WardrobeItemTile({
    super.key,
    required this.item,
    required this.onLongPress,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SafeImage(
                      path: item.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.shadowBlack,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: item.isFavorite
                            ? AppColors.favorite
                            : AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Column(
            children: [
              Text(
                item.category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                item.color,
                style: TextStyle(
                  color: AppColors.grey.shade600,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${item.wearCount} wears',
                style: TextStyle(
                  color: AppColors.grey.shade500,
                  fontSize: 11,
                ),
              ),

              if (item.lastWorn != null)
                Text(
                  'Last worn: '
                  '${item.lastWorn!.day}/'
                  '${item.lastWorn!.month}',
                  style: TextStyle(
                    color: AppColors.grey.shade500,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}