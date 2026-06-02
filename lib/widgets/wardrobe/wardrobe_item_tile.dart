import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

class WardrobeItemTile extends StatelessWidget {
  final WardrobeItem item;
  final VoidCallback onLongPress;

  const WardrobeItemTile({
    super.key,
    required this.item,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SafeImage(
                path: item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
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