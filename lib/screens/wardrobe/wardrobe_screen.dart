import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/wardrobe_constants.dart';
import 'package:wardrobe_ai/models/outfit_history.dart';
import 'package:wardrobe_ai/screens/history/outfit_history_screen.dart';
import 'package:wardrobe_ai/screens/outfit/outfit_detail_screen.dart';
import 'package:wardrobe_ai/screens/stats/stats_screen.dart';
import 'package:wardrobe_ai/screens/wardrobe/add_item_screen.dart';
import 'package:wardrobe_ai/services/history/outfit_history_service.dart';
import 'package:wardrobe_ai/services/storage_service.dart';
import 'package:wardrobe_ai/services/wardrobe/wardrobe_manager.dart';
import 'package:wardrobe_ai/services/wardrobe/wardrobe_service.dart';
import 'package:wardrobe_ai/widgets/app_snackbar.dart';
import 'package:wardrobe_ai/widgets/wardrobe/category_filter_bar.dart';
import 'package:wardrobe_ai/widgets/wardrobe/edit_item_dialog.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_app_bar.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_fab_column.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_grid.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_search_bar.dart';
import 'package:wardrobe_ai/widgets/wardrobe/wardrobe_actions_sheet.dart';

import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';

import '../../services/outfit/outfit_generator_service.dart';

import '../outfit/outfit_screen.dart';


class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {

  List<WardrobeItem> _items = [];
  List<Outfit> _outfits = [];
  List<OutfitHistory> _history = [];
  bool _showFavoritesOnly = false;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortOption = 'Recent';

  List<WardrobeItem> get _filteredItems =>
    WardrobeService.getFilteredItems(
      items: _items,
      selectedCategory: _selectedCategory,
      searchQuery: _searchQuery,
      sortOption: _sortOption,
      showFavoritesOnly: _showFavoritesOnly,
    );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data =
        await WardrobeManager.loadData();

    if (!mounted) return;

    setState(() {
      _items = data.items;
      _outfits = data.outfits;
      _history = data.history;
    });
  }

  Future<void> _saveData() {
    return WardrobeManager.saveData(
      items: _items,
      outfits: _outfits,
    );
  }

  Future<void> _addOutfit(Outfit outfit) async {
    setState(() {
      WardrobeManager.addOutfit(
        outfits: _outfits,
        outfit: outfit,
      );
    });

    await _saveData();
  }

  Future<void> _addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddItemScreen(),
      ),
    );

    if (result == null) return;

    final imagePaths =
        List<String>.from(result['imagePaths']);

    final category = result['category'];
    final color = result['color'];  

    if (category == null || color == null) return;

    setState(() {
      WardrobeManager.addItems(
        items: _items,
        imagePaths: imagePaths,
        category: category,
        color: color,
      );
    });

    await _saveData();
  }

  Future<void> _deleteItem(
    WardrobeItem item,
  ) async {
    final removedOutfits =
        WardrobeManager.deleteItem(
      item: item,
      items: _items,
      outfits: _outfits,
    );

    setState(() {});

    await _saveData();

    if (removedOutfits) {
      AppSnackBar.show(
        context,
        'Some outfits were removed because items were deleted.',
      );
    }
  }

  Future<void> _editItem(
    WardrobeItem item,
  ) async {
    final result =
        await showEditItemDialog(
      context: context,
      category: item.category,
      color: item.color,
    );

    if (result == null) return;

    final category = result['category'];
    final color = result['color'];

    if (category == null || color == null) return;

    final updated = WardrobeManager.updateItem(
      items: _items,
      item: item,
      category: category,
      color: color,
    );

    if (!updated) return;

    setState(() {});

    await _saveData();
  }

  void _generateOutfit(
    String occasion,
    String weather,
  ) {
    final outfit =
        OutfitGeneratorService.generateOutfit(
      items: _items,
      occasion: occasion,
      weather: weather,
    );

    if (outfit == null) {
      AppSnackBar.show(
        context,
        'Not enough wardrobe items to generate an outfit',
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutfitDetailScreen(
          outfit: outfit,
          onSave: _addOutfit,
          onWorn: _recordOutfitHistory,
          wardrobeItems: _items,
        ),
      ),
    );
  }

  void _changeSortOption(String value) =>
      setState(() => _sortOption = value);

  void _changeCategory(String category) =>
      setState(() => _selectedCategory = category);

  void _changeSearchQuery(String value) =>
      setState(() => _searchQuery = value);

  Future<void> _openOutfits() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OutfitScreen(),
      ),
    );
  }

  void _showItemActions(WardrobeItem item) {
    showWardrobeActionsSheet(
      context: context,
      onEdit: () => _editItem(item),
      onDelete: () => _deleteItem(item),
    );
  }

  Future<void> _toggleFavorite(
    WardrobeItem item,
  ) async {
    final updated =
        WardrobeManager.toggleFavorite(
      items: _items,
      item: item,
    );

    if (!updated) return;

    setState(() {});

    await _saveData();
  }

  void _toggleFavoritesFilter() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
    });
  }

  Future<void> _openStats() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatsScreen(
          items: _items,
          outfits: _outfits,
        ),
      ),
    );
  }

  Future<void> _recordOutfitHistory(
    Outfit outfit,
  ) async {

    final index =
        _outfits.indexWhere((o) => o.id == outfit.id);

    if (index != -1) {
      _outfits[index] = outfit;
      await _saveData();
    }

    OutfitHistoryService.addHistoryEntry(
      history: _history,
      outfit: outfit,
    );

    await StorageService.saveHistory(_history);
  }

  Future<void> _openHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutfitHistoryScreen(
          history: _history,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WardrobeAppBar(
        onOpenOutfits: _openOutfits,
        onSortChanged: _changeSortOption,
        showFavoritesOnly: _showFavoritesOnly,
        onToggleFavorites: _toggleFavoritesFilter,
        onOpenStats: _openStats,
        onOpenHistory: _openHistory,
      ),
      body: Column(
        children: [
          CategoryFilterBar(
            categories: WardrobeConstants.filterCategories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _changeCategory,
          ),
          WardrobeSearchBar(
            onChanged: _changeSearchQuery,
          ),
          WardrobeGrid(
            items: _filteredItems,
            onItemLongPress: _showItemActions,
            onFavoriteToggle: _toggleFavorite,
          ),
        ],
      ),
      floatingActionButton: WardrobeFabColumn(
        items: _items,
        onAddItem: _addItem,
        onGenerate: _generateOutfit,
        onOutfitCreated: _addOutfit,
      ),
    );
  }
}
