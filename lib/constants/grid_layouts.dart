import 'package:flutter/material.dart';

class GridLayouts {
  static const outfitPreview =
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 24,
    mainAxisSpacing: 24,
  );

  static const wardrobeSelection =
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  );

  static const outfitGrid =
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  );

  static const outfitCardPreview =
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 2,
    mainAxisSpacing: 2,
  );
}