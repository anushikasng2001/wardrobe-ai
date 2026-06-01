import 'package:flutter/material.dart';

class WardrobeAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final Function(String value) onSortChanged;
  final VoidCallback onOpenOutfits;

  const WardrobeAppBar({
    super.key,
    required this.onSortChanged,
    required this.onOpenOutfits,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Wardrobe'),

      actions: [

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