import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';

class WardrobeAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final Function(String value) onSortChanged;
  final VoidCallback onOpenOutfits;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavorites;

  const WardrobeAppBar({
    super.key,
    required this.onSortChanged,
    required this.onOpenOutfits,
    required this.showFavoritesOnly,
    required this.onToggleFavorites, 
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Wardrobe'),

      actions: [

        IconButton(
          icon: Icon(
            showFavoritesOnly
                ? Icons.favorite
                : Icons.favorite_border,
            color: showFavoritesOnly
                  ? AppColors.favorite
                  : AppColors.grey,
          ),
          onPressed: onToggleFavorites,
        ),

        IconButton(
          icon: const Icon(Icons.grid_view),
          onPressed: onOpenOutfits,
        ),

        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: onSortChanged,
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'Recent',
              child: Text('Recent'),
            ),
            const PopupMenuItem(
              value: 'Most Worn',
              child: Text('Most Worn'),
            ),
            const PopupMenuItem(
              value: 'Least Worn',
              child: Text('Least Worn'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}