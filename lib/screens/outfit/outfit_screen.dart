import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/services/storage_service.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_actions_sheet.dart' show showOutfitActionsSheet;
import 'package:wardrobe_ai/widgets/outfit/outfit_grid.dart';
import 'package:wardrobe_ai/widgets/outfit/rename_outfit_dialog.dart';

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

  List<Outfit> get displayedOutfits =>
    showFavoritesOnly
        ? outfits.where((o) => o.isFavorite).toList()
        : outfits;

  @override
  void initState() {
    super.initState();
    _loadOutfits();
  }

  Future<void> _loadOutfits() async {
    final loadedOutfits =
        await StorageService.loadOutfits();

    if (!mounted) return;

    setState(() {
      outfits = loadedOutfits;
    });
  }

  Future<void> _saveOutfits() async {
    await StorageService.saveOutfits(outfits);
  }

  Future<void> _deleteOutfit(Outfit outfit) async {
    setState(() {
      outfits.removeWhere((o) => o.id == outfit.id);
    });

    await _saveOutfits();
  }

  Future<void> _toggleFavorite(Outfit outfit) async {
    final index =
        outfits.indexWhere((o) => o.id == outfit.id);

    if (index == -1) return;

    setState(() {
      outfits[index] = outfits[index].copyWith(
        isFavorite: !outfits[index].isFavorite,
      );
    });

    await _saveOutfits();
  }

  void _toggleFavoritesFilter() {
    setState(() {
      showFavoritesOnly = !showFavoritesOnly;
    });
  }

  void _openOutfit(Outfit outfit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutfitDetailScreen(
          outfit: outfit,

          onUpdate: (updatedOutfit) async {

            final index = outfits.indexWhere(
              (o) => o.id == updatedOutfit.id,
            );

            if (index == -1) return;

            setState(() {
              outfits[index] = updatedOutfit;
            });

            await _saveOutfits();
          },
        ),
      ),
    );
  }

  Future<void> _renameOutfit(Outfit outfit) async {
    final newName = await showRenameOutfitDialog( context, outfit.name );

    if (newName == null || newName.isEmpty) {
      return;
    }

    final index =
        outfits.indexWhere((o) => o.id == outfit.id);

    if (index == -1) return;

    setState(() {
      outfits[index] = outfits[index].copyWith(
        name: newName,
      );
    });

    await _saveOutfits();
  }

  void _showOutfitActions(Outfit outfit) {
    showOutfitActionsSheet(
      context: context,
      onRename: () => _renameOutfit(outfit),
      onDelete: () => _deleteOutfit(outfit),
    );
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
              color: showFavoritesOnly
                  ? AppColors.favorite
                  : AppColors.grey,
            ),
            onPressed: _toggleFavoritesFilter,
          ),
        ],
      ),
      body: displayedOutfits.isEmpty
      ? const Center(
          child: Text(
            'No outfits created yet',
          ),
        )
      : OutfitGrid(
          outfits: displayedOutfits,
          onTap: _openOutfit,
          onLongPress: _showOutfitActions,
          onFavorite: _toggleFavorite,
        ),
    );
  }
}
