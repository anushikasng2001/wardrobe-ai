import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_ai/constants/grid_layouts.dart';
import 'package:wardrobe_ai/services/image/safe_image.dart';

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
      gridDelegate: GridLayouts.wardrobeSelection,
      itemBuilder: (context, index) {
        return SafeImage(
          path: images[index].path,
        );
      },
    );
  }
}