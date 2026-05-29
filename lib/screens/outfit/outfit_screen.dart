import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

import '../../models/outfit.dart';
import 'outfit_detail_screen.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  List<Outfit> outfits = [];
  bool showFavoritesOnly = false;

  List<Outfit> get displayedOutfits {
    if (showFavoritesOnly) {
      return outfits.where((o) => o.isFavorite).toList();
    }
    return outfits;
  }

  @override
  void initState() {
    super.initState();
    loadOutfits();
  }

  Future<void> loadOutfits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('outfits');

    if (data != null) {
      setState(() {
        outfits = Outfit.decode(data);
      });
    }
  }

  Future<void> saveOutfits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('outfits', Outfit.encode(outfits));
  }

  void deleteOutfit(String id) {
    setState(() {
      outfits.removeWhere((o) => o.id == id);
    });

    saveOutfits();
  }

  void toggleFavorite(String id) {
    final index = outfits.indexWhere((o) => o.id == id);

    if (index == -1) return;

    setState(() {
      outfits[index] = outfits[index].copyWith(
        isFavorite: !outfits[index].isFavorite,
      );
    });

    saveOutfits();
  }

  Widget buildOutfitPreview(List<String> images) {
    final displayImages = images.take(4).toList();

    if (displayImages.length == 1) {
      return SafeImage(
        path: displayImages.first,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: displayImages.length,
      itemBuilder: (context, index) {
        return SafeImage(
          path: displayImages[index],
          fit: BoxFit.cover,
        );
      },
    );
  }

  Future<void> renameOutfit(String outfitId) async {
    final outfitIndex = outfits.indexWhere((o) => o.id == outfitId);

    if (outfitIndex == -1) return;

    final controller = TextEditingController(
      text: outfits[outfitIndex].name,
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Outfit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Outfit name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;

    setState(() {
      outfits[outfitIndex] = outfits[outfitIndex].copyWith(
        name: newName,
      );
    });

    await saveOutfits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Outfits'),
        actions: [
          IconButton(
            icon: Icon(
              showFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      body: outfits.isEmpty
          ? const Center(
              child: Text('No outfits created yet'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: displayedOutfits.length,
              itemBuilder: (context, index) {
                final outfit = displayedOutfits[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OutfitDetailScreen(outfit: outfit),
                      ),
                    );
                  },
                  onLongPress: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Rename'),
                          onTap: () {
                            Navigator.pop(context);
                            renameOutfit(outfit.id);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            deleteOutfit(outfit.id);
                          },
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildOutfitPreview(outfit.imagePaths),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  outfit.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  outfit.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: outfit.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  toggleFavorite(outfit.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
