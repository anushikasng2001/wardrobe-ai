import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/grid_layouts.dart';
import 'package:wardrobe_ai/widgets/app_snackbar.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_selection_tile.dart';
import '../../models/wardrobe_item.dart';

class CreateOutfitScreen extends StatefulWidget {
  final List<WardrobeItem> items;

  const CreateOutfitScreen({super.key, required this.items});

  @override
  State<CreateOutfitScreen> createState() => _CreateOutfitScreenState();
}

class _CreateOutfitScreenState extends State<CreateOutfitScreen> {
  final Set<WardrobeItem> selectedItems = {};
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _saveOutfit() {
    if (nameController.text.isEmpty || selectedItems.isEmpty) {
      AppSnackBar.show(
        context,
        'Please enter outfit name and select items',
      );
      return;
    }

    Navigator.pop(context, {
      'name': nameController.text,
      'items': selectedItems.map((e) => e.imagePath).toList(),
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Outfit')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: nameController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Outfit Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.items.length,
              gridDelegate: GridLayouts.wardrobeSelection,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = selectedItems.contains(item);

                return OutfitSelectionTile(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(item);
                      } else {
                        selectedItems.add(item);
                      }
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed:
                selectedItems.isEmpty ||
                        nameController.text.trim().isEmpty
                    ? null
                    : _saveOutfit,
            child: const Text('Save Outfit'),
          ),
        ],
      ),
    );
  }
}
