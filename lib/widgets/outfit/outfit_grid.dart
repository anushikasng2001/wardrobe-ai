import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/grid_layouts.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_card.dart';

class OutfitGrid extends StatelessWidget {
  final List<Outfit> outfits;
  final ValueChanged<Outfit> onTap;
  final ValueChanged<Outfit> onLongPress;
  final ValueChanged<Outfit> onFavorite;

  const OutfitGrid({
    super.key,
    required this.outfits,
    required this.onTap,
    required this.onLongPress,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: GridLayouts.outfitGrid,
      itemCount: outfits.length,
      itemBuilder: (_, index) {
        final outfit = outfits[index];

        return OutfitCard(
          outfit: outfit,
          onTap: () => onTap(outfit),
          onLongPress: () => onLongPress(outfit),
          onFavorite: () => onFavorite(outfit),
        );
      },
    );
  }
}