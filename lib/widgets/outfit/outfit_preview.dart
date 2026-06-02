import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/grid_layouts.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_image_tile.dart';

class OutfitPreview extends StatelessWidget {
  final List<String> images;

  const OutfitPreview({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final displayImages = images.take(4).toList();

    if (displayImages.length == 1) {
      return OutfitImageTile(
        imagePath: displayImages.first,
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: displayImages.length,
      gridDelegate: GridLayouts.outfitCardPreview,
      itemBuilder: (_, index) {
        return OutfitImageTile(
          imagePath: displayImages[index],
          borderRadius: 0,
          showShadow: false,
        );
      },
    );
  }
}