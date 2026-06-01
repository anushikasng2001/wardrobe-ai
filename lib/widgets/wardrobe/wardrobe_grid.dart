import 'package:flutter/material.dart';

import '../../models/wardrobe_item.dart';
import 'wardrobe_item_tile.dart';

class WardrobeGrid extends StatelessWidget {
  final List<WardrobeItem> items;
  final void Function(WardrobeItem item) onItemLongPress;

  const WardrobeGrid({
    super.key,
    required this.items,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: items.isEmpty
          ? const Center(
              child: Text(
                'No items in this category',
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),

              itemCount: items.length,

              itemBuilder: (context, index) {
                final item = items[index];

                return WardrobeItemTile(
                  item: item,
                  onLongPress: () => onItemLongPress(item),
                );
              },
            ),
    );
  }
}