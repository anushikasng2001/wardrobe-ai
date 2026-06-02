import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

class OutfitSelectionTile extends StatelessWidget {
  final WardrobeItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const OutfitSelectionTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeImage(path: item.imagePath),

          if (isSelected)
            Container(
              color: AppColors.black26
            ),

          if (isSelected)
            const Positioned(
              top: 4,
              right: 4,
              child: Icon(
                Icons.check_circle,
                color: AppColors.selected,
              ),
            ),
        ],
      )
    );
  }
}