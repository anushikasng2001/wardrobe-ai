import 'package:flutter/material.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

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
      return SafeImage(
        path: displayImages.first,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: displayImages.length,
      itemBuilder: (_, index) {
        return SafeImage(
          path: displayImages[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}