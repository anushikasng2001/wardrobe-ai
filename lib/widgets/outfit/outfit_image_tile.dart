import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/services/image/safe_image.dart';

class OutfitImageTile extends StatelessWidget {

  final String imagePath;
  final double borderRadius;
  final bool showShadow;

  const OutfitImageTile({
    super.key,
    required this.imagePath,
    this.borderRadius = 24,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SafeImage(
          path: imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}