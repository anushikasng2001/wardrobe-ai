import 'package:flutter/material.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_image_tile.dart';

class OutfitPreviewGrid extends StatelessWidget {
  final List<String> imagePaths;

  const OutfitPreviewGrid({
    super.key,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: imagePaths.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemBuilder: (_, index) {
        return OutfitImageTile(
          imagePath: imagePaths[index],
        );
      },
    );
  }
}