import 'dart:io';
import 'package:flutter/material.dart';
import '../models/wardrobe_item.dart';

class CreateOutfitScreen extends StatefulWidget {
  final List<WardrobeItem> items;

  const CreateOutfitScreen({super.key, required this.items});

  @override
  State<CreateOutfitScreen> createState() => _CreateOutfitScreenState();
}

class _CreateOutfitScreenState extends State<CreateOutfitScreen> {
  final Set<WardrobeItem> selectedItems = {};
  final TextEditingController nameController = TextEditingController();

  void saveOutfit() {
    if (nameController.text.isEmpty || selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter outfit name and select items'),
        ),
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
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = selectedItems.contains(item);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? selectedItems.remove(item)
                          : selectedItems.add(item);
                    });
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          File(item.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: saveOutfit,
            child: const Text('Save Outfit'),
          ),
        ],
      ),
    );
  }
}
