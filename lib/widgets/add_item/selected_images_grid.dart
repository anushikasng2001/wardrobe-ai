import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/constants/grid_layouts.dart';
import 'package:wardrobe_ai/models/pending_wardrobe_image.dart';
import 'package:wardrobe_ai/services/image/safe_image.dart';

class SelectedImagesGrid extends StatelessWidget {
  final List<PendingWardrobeImage> images;

  const SelectedImagesGrid({
    super.key,
    required this.images,
  });

  Color _mapColor(String color) {
    switch (color.toLowerCase()) {
      case 'black':
        return AppColors.black;
      case 'white':
        return AppColors.white;
      case 'blue':
        return AppColors.blue;
      case 'red':
        return AppColors.red;
      case 'green':
        return AppColors.green;
      case 'yellow':
        return AppColors.yellow;
      case 'pink':
        return AppColors.pink;
      case 'purple':
        return AppColors.purple;
      case 'brown':
        return AppColors.brown;
      case 'grey':
        return AppColors.grey;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: GridLayouts.wardrobeSelection,
      itemBuilder: (context, index) {
        final item = images[index];

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: SafeImage(
                  path: item.image.path,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.detectedCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _mapColor(item.detectedColor),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}