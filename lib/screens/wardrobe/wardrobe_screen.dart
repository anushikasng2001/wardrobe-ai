import 'package:flutter/material.dart';
import 'package:wardrobe_ai/screens/add_item_screen.dart';
import 'package:wardrobe_ai/screens/outfit/outfit_detail_screen.dart';
import 'package:wardrobe_ai/services/wardrobe_service.dart';
import 'package:wardrobe_ai/widgets/wardrobe/category_filter_bar.dart';
import 'package:wardrobe_ai/widgets/wardrobe/delete_item_sheet.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_app_bar.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_fab_column.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_grid.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_search_bar.dart';

import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';

import '../../services/outfit_service.dart';
import '../../services/storage_service.dart';
import '../../services/outfit_generator_service.dart';

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

  List<WardrobeItem> get filteredItems =>
    WardrobeService.getFilteredItems(
      items: items,
      selectedCategory: selectedCategory,
      searchQuery: searchQuery,
      sortOption: sortOption,
    );



  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedItems = await StorageService.loadItems();
    final loadedOutfits = await StorageService.loadOutfits();

    if (!mounted) return;

    setState(() {
      items = loadedItems;
      outfits = loadedOutfits;
    });
  }

  Future<void> _saveData() async {
    await StorageService.saveItems(items);
    await StorageService.saveOutfits(outfits);
  }

  Future<void> _addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddItemScreen(),
      ),
    );

    if (result == null) return;

    final imagePaths = List<String>.from(result['imagePaths']);
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
            createdAt: DateTime.now(),
          ),
        );
      }
    });

    await _saveData();
  }

  Future<void> _deleteItem(WardrobeItem item) async {
    final removedOutfits = OutfitService.deleteItem(
      item: item,
      items: items,
      outfits: outfits,
    );

    setState(() {});

    await _saveData();

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

  void _changeSortOption(String value) {
    setState(() {
      sortOption = value;
    });
  }

  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _changeSearchQuery(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  Future<void> _addOutfit(Outfit outfit) async {
    setState(() {
      outfits.add(outfit);
    });

    await _saveData();
  }

  Future<void> _openOutfits() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OutfitScreen(),
      ),
    );
  }

  void _showDeleteItem(WardrobeItem item) {
    showDeleteItemSheet(
      context: context,
      onDelete: () => _deleteItem(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WardrobeAppBar(
        onOpenOutfits: _openOutfits,
        onSortChanged: _changeSortOption,
      ),
      body: Column(
        children: [
          CategoryFilterBar(
            categories: WardrobeService.categories,
            selectedCategory: selectedCategory,
            onCategorySelected: _changeCategory,
          ),
          WardrobeSearchBar(
            onChanged: _changeSearchQuery,
          ),
          WardrobeGrid(
            items: filteredItems,
            onItemLongPress: _showDeleteItem,
          ),
        ],
      ),
      floatingActionButton: WardrobeFabColumn(
        items: items,
        onAddItem: _addItem,
        onGenerate: _generateOutfit,
        onOutfitCreated: _addOutfit,
      ),
    );
  }
}
