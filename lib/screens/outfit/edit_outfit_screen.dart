import 'package:flutter/material.dart';

import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';
import '../../widgets/safe_image.dart';

class EditOutfitScreen extends StatefulWidget {
  final Outfit outfit;
  final List<WardrobeItem> wardrobeItems;

  const EditOutfitScreen({
    super.key,
    required this.outfit,
    required this.wardrobeItems,
  });

  @override
  State<EditOutfitScreen> createState() =>
      _EditOutfitScreenState();
}

class _EditOutfitScreenState
    extends State<EditOutfitScreen> {

  late List<String> imagePaths;

  @override
  void initState() {
    super.initState();

    imagePaths =
        List<String>.from(widget.outfit.imagePaths);
  }

  Future<void> _replaceItem(
    int index,
  ) async {

    final selected =
        await showModalBottomSheet<WardrobeItem>(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount:
              widget.wardrobeItems.length,
          itemBuilder: (_, i) {

            final item =
                widget.wardrobeItems[i];

            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: SafeImage(
                  path: item.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item.category),
              subtitle: Text(item.color),
              onTap: () {
                Navigator.pop(
                  context,
                  item,
                );
              },
            );
          },
        );
      },
    );

    if (selected == null) return;

    setState(() {
      imagePaths[index] =
          selected.imagePath;
    });
  }

  void _save() {

    final editedOutfit =
        widget.outfit.copyWith(
      imagePaths: imagePaths,
    );

    Navigator.pop(
      context,
      editedOutfit,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Outfit',
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: const Text(
          'Save Changes',
        ),
      ),

      body: GridView.builder(
        padding:
            const EdgeInsets.all(16),

        itemCount: imagePaths.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),

        itemBuilder: (_, index) {

          return GestureDetector(
            onTap: () =>
                _replaceItem(index),

            child: Stack(
              children: [

                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12),

                    child: SafeImage(
                      path:
                          imagePaths[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  right: 8,
                  top: 8,

                  child: Container(
                    padding:
                        const EdgeInsets.all(6),

                    decoration:
                        const BoxDecoration(
                      color: Colors.black54,
                      shape:
                          BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}