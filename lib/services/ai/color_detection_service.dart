import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorDetectionService {
  static Future<String> detectColor(
    String imagePath,
  ) async {

    final palette =
        await PaletteGenerator.fromImageProvider(
      FileImage(
        File(imagePath),
      ),
    );

    final color =
        palette.dominantColor?.color;

    if (color == null) {
      return 'Unknown';
    }

    return _mapColor(color);
  }

  static String _mapColor(
    Color color,
  ) {

    final r = color.red;
    final g = color.green;
    final b = color.blue;

    if (r > 180 &&
        g > 180 &&
        b > 180) {
      return 'White';
    }

    if (r < 60 &&
        g < 60 &&
        b < 60) {
      return 'Black';
    }

    if (b > r &&
        b > g) {
      return 'Blue';
    }

    if (r > g &&
        r > b) {
      return 'Red';
    }

    if (g > r &&
        g > b) {
      return 'Green';
    }

    return 'Other';
  }
}