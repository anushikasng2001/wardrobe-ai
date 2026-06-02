import 'package:flutter/material.dart';
import 'package:wardrobe_ai/models/outfit.dart';

import '../../models/wardrobe_item.dart';
import '../../screens/outfit/create_outfit_screen.dart';
import 'generate_outfit_dialog.dart';

class WardrobeFabColumn extends StatelessWidget {
  final List<WardrobeItem> items;
  final Future<void> Function() onAddItem;
  final void Function(String occasion, String weather) onGenerate;
  final ValueChanged<Outfit> onOutfitCreated;

  const WardrobeFabColumn({
    super.key,
    required this.items,
    required this.onGenerate,
    required this.onOutfitCreated,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'add_item',
          onPressed: onAddItem,
          child: const Icon(Icons.add),
        ),

        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'create_outfit',
          child: const Icon(Icons.style),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateOutfitScreen(
                  items: items,
                ),
              ),
            );

            if (result != null) {
              onOutfitCreated(
                Outfit(
                  id: DateTime.now()
                      .microsecondsSinceEpoch
                      .toString(),
                  name: result['name'],
                  imagePaths: List<String>.from(
                    result['items'],
                  ),
                  createdAt: DateTime.now(),
                ),
              );
            }
          },
        ),

        const SizedBox(height: 12),

        FloatingActionButton(
          heroTag: 'generate_ai',
          child: const Icon(Icons.auto_awesome),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => GenerateOutfitDialog(
                onGenerate: onGenerate,
              ),
            );
          },
        ),
      ],
    );
  }
}