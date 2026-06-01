import 'package:flutter/material.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_preview_grid.dart';

class OutfitShareCard extends StatelessWidget {
  final Outfit outfit;
  final GlobalKey repaintKey;

  const OutfitShareCard({
    super.key,
    required this.outfit,
    required this.repaintKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        width: 1080,
        height: 1080,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F6F2),
              Color(0xFFE8E1D9),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              outfit.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Styled with Wardrobe AI',
            ),
            const SizedBox(height: 24),
            Expanded(
              child: OutfitPreviewGrid(
                imagePaths:
                    outfit.imagePaths,
              ),
            ),
          ],
        ),
      ),
    );
  }
}