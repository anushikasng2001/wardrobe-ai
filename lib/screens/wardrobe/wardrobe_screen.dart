import 'package:flutter/material.dart';
import 'package:wardrobe_ai/screens/outfit/outfit_detail_screen.dart';
import 'package:wardrobe_ai/services/wardrobe_service.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';

import '../../services/outfit_service.dart';
import '../../services/storage_service.dart';
import '../../services/outfit_generator_service.dart';

import '../add_item_screen.dart';
import '../create_outfit_screen.dart';

import '../outfit/outfit_screen.dart';


class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {

  List<WardrobeItem> items = [];
  List<Outfit> outfits = [];

  String selectedCategory = 'All';
  String searchQuery = '';
  String sortOption = 'Recent';

  List<WardrobeItem> get filteredItems {
    return WardrobeService.getFilteredItems(
      items: items,
      selectedCategory: selectedCategory,
      searchQuery: searchQuery,
      sortOption: sortOption,
    );
  }



  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {

    final loadedItems = await StorageService.loadItems();
    final loadedOutfits = await StorageService.loadOutfits();

    setState(() {
      items = loadedItems;
      outfits = loadedOutfits;
    });
  }

  void _deleteItem(WardrobeItem item) {

    final removedOutfits =
        OutfitService.deleteItem(
          item: item,
          items: items,
          outfits: outfits,
        );

    setState(() {
      items = List.from(items);
      outfits = List.from(outfits);
    });

    StorageService.saveItems(
      items,
    );

    StorageService.saveOutfits(
      outfits,
    );

    if (removedOutfits) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Some outfits were removed because items were deleted.',
          ),
        ),
      );
    }
  }

  void _generateOutfit(
    String occasion,
    String weather,
  ) {
    final outfit =
        OutfitGeneratorService.generateOutfit(
      items: items,
      occasion: occasion,
      weather: weather,
    );

    if (outfit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough wardrobe items'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutfitDetailScreen(
          outfit: outfit,
        ),
      ),
    );
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

                    _generateOutfit(
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                sortOption = value;
              });
            },
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: WardrobeService.categories.map((category) {
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search wardrobe...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
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
                                child: SafeImage(
                                  path: item.imagePath,
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

                                const SizedBox(height: 4),

                                Text(
                                  '${item.wearCount} wears',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                  ),
                                ),

                                if (item.lastWorn != null)
                                  Text(
                                    'Last worn: '
                                    '${item.lastWorn!.day}/'
                                    '${item.lastWorn!.month}',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 10,
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
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          imagePath: path,
                          category: category,
                          color: color,
                          tags: [],
                          createdAt: DateTime.now()
                      ),
                    );
                  }
                });

                StorageService.saveItems(items);
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
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      name: result['name'],
                      imagePaths: List<String>.from(result['items']),
                      createdAt: DateTime.now(),
                    )
                  );
                });

                StorageService.saveOutfits(outfits);
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
