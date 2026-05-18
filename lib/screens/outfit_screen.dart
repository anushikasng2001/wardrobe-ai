import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/outfit.dart';
import 'outfit_detail_screen.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  List<Outfit> outfits = [];

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

  void deleteOutfit(int index) {
    setState(() {
      outfits.removeAt(index);
    });
    saveOutfits();
  }

  void toggleFavorite(int index) {
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
      return Image.file(
        File(displayImages.first),
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
        return Image.file(
          File(displayImages[index]),
          fit: BoxFit.cover,
        );
      },
    );
  }

  Future<void> renameOutfit(int index) async {
    final controller = TextEditingController(text: outfits[index].name);

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
      outfits[index] = outfits[index].copyWith(name: newName);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('outfits', Outfit.encode(outfits));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Outfits'),
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
              itemCount: outfits.length,
              itemBuilder: (context, index) {
                final outfit = outfits[index];

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
                            renameOutfit(index);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            deleteOutfit(index);
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
                                  toggleFavorite(index);
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
