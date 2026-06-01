import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

class SelectedImagesGrid extends StatelessWidget {
  final List<XFile> images;

  const SelectedImagesGrid({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return SafeImage(
          path: images[index].path,
        );
      },
    );
  }
}