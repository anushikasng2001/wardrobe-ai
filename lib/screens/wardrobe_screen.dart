import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_ai/screens/outfit_detail_screen.dart';

import '../models/outfit.dart';
import '../models/wardrobe_item.dart';

import 'add_item_screen.dart';
import 'create_outfit_screen.dart';

import 'outfit_screen.dart';


class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Top',
    'Bottom',
    'Dress',
    'Shoes',
    'Accessories',
    'Jacket',
  ];

  List<WardrobeItem> items = [];
  List<Outfit> outfits = [];

  List<WardrobeItem> get filteredItems {
    if (selectedCategory == 'All') return items;
    return items.where((i) => i.category == selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    loadItems();
    loadOutfits();
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('wardrobe_items');
    if (data != null) {
      setState(() {
        items = WardrobeItem.decode(data);
      });
    }
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

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wardrobe_items', WardrobeItem.encode(items));
  }

  Future<void> saveOutfits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('outfits', Outfit.encode(outfits));
  }

  void showGenerateDialog() {
    String selectedOccasion = 'Casual';
    String selectedWeather = 'Hot';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Generate Outfit'),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  DropdownButton<String>(
                    value: selectedOccasion,
                    isExpanded: true,
                    items: [
                      'Casual',
                      'Office',
                      'Party',
                      'Gym',
                    ]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedOccasion = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButton<String>(
                    value: selectedWeather,
                    isExpanded: true,
                    items: [
                      'Hot',
                      'Cold',
                      'Rainy',
                    ]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedWeather = value!;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    generateOutfit(
                      selectedOccasion,
                      selectedWeather,
                    );
                  },
                  child: const Text('Generate'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool colorsMatch(String topColor, String bottomColor) {
    final goodMatches = {
      'Black': ['White', 'Grey', 'Beige', 'Blue', 'Black'],
      'White': ['Black', 'Blue', 'Grey', 'Beige'],
      'Blue': ['White', 'Black', 'Grey'],
      'Beige': ['Black', 'White', 'Brown'],
      'Grey': ['Black', 'White', 'Blue'],
    };

    return goodMatches[topColor]?.contains(bottomColor) ?? true;
  }

  void generateOutfit(
    String occasion,
    String weather,
  ) {
    final tops =
        items.where((i) => i.category == 'Top').toList();

    final bottoms =
        items.where((i) => i.category == 'Bottom').toList();

    final shoes =
        items.where((i) => i.category == 'Shoes').toList();

    final jackets =
        items.where((i) => i.category == 'Jacket').toList();

    if (tops.isEmpty || bottoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough wardrobe items'),
        ),
      );
      return;
    }

    tops.shuffle();
    bottoms.shuffle();

    WardrobeItem? selectedTop;
    WardrobeItem? selectedBottom;

    for (final top in tops) {
      for (final bottom in bottoms) {
        if (colorsMatch(top.color, bottom.color)) {
          selectedTop = top;
          selectedBottom = bottom;
          break;
        }
      }
    }

    selectedTop ??= tops.first;
    selectedBottom ??= bottoms.first;

    final selected = <String>[
      selectedTop.imagePath,
      selectedBottom.imagePath,
    ];

    if (shoes.isNotEmpty) {
      shoes.shuffle();
      selected.add(shoes.first.imagePath);
    }

    if (weather == 'Cold' && jackets.isNotEmpty) {
      jackets.shuffle();
      selected.add(jackets.first.imagePath);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutfitDetailScreen(
          outfit: Outfit(
            id: DateTime.now().toString(),
            name: '$occasion Outfit',
            imagePaths: selected,
          ),
        ),
      ),
    );
  }

  void _showDeleteSheet(WardrobeItem item) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Item'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteItem(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteItem(WardrobeItem item) {
    setState(() {
      items.remove(item);

      // Remove deleted item from outfits as well (important!)
      for (final outfit in outfits) {
        outfit.imagePaths.remove(item.imagePath);
      }
    });

    saveItems();
    saveOutfits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OutfitScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: categories.map((category) {
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('No items in this category'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return GestureDetector(
                        onLongPress: () => _showDeleteSheet(item),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(item.imagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Column(
                              children: [
                                Text(
                                  item.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.color,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_item',
            child: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddItemScreen(),
                ),
              );

              if (result != null) {
                final imagePaths =
                    List<String>.from(result['imagePaths']);
                final category = result['category'];
                final color = result['color'];

                setState(() {
                  for (final path in imagePaths) {
                    items.add(
                      WardrobeItem(
                        imagePath: path,
                        category: category,
                        color: color,
                        tags: [],
                      ),
                    );
                  }
                });

                saveItems();
              }
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'create_outfit',
            child: const Icon(Icons.style),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateOutfitScreen(items: items),
                ),
              );

              if (result != null) {
                setState(() {
                  outfits.add(
                    Outfit(
                      id: DateTime.now().toIso8601String(),
                      name: result['name'],
                      imagePaths: List<String>.from(result['items']),
                    ),
                  );
                });

                saveOutfits();
              }
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'generate_ai',
            child: const Icon(Icons.auto_awesome),
            onPressed: () {
              showGenerateDialog();
            },
          ),
        ],
      ),
    );
  }
}
