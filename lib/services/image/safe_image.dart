import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';

class SafeImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SafeImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(path);

    if (!file.existsSync()) {
      return Container(
        width: width,
        height: height,
        color: AppColors.grey.shade200,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              color: AppColors.grey,
            ),
            SizedBox(height: 4),
            Text(
              'Image missing',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Image.file(
      file,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) {
        return Container(
          color: AppColors.grey.shade200,
          child: const Icon(
            Icons.broken_image,
            color: AppColors.grey,
          ),
        );
      },
    );
  }
}