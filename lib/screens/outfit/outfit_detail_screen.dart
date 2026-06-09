import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/screens/outfit/edit_outfit_screen.dart';
import 'package:wardrobe_ai/widgets/app_snackbar.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_rating_bar.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_share_card.dart';
import 'package:wardrobe_ai/services/outfit/outfit_share_service.dart';
import 'package:wardrobe_ai/services/outfit/outfit_wear_service.dart';

class OutfitDetailScreen extends StatefulWidget {
  final Outfit outfit;
  final Future<void> Function(Outfit)? onSave;
  final List<WardrobeItem> wardrobeItems;
  final Future<void> Function(Outfit)? onWorn;
  final Future<void> Function(Outfit)? onUpdate;

  const OutfitDetailScreen({
    super.key,
    required this.outfit,
    this.onSave,
    this.onWorn,
    this.onUpdate,
    this.wardrobeItems = const [],
  });

  @override
    State<OutfitDetailScreen> createState() =>
        _OutfitDetailScreenState();
  }

class _OutfitDetailScreenState
    extends State<OutfitDetailScreen> {
  final GlobalKey repaintKey = GlobalKey();
  late Outfit _outfit;
  bool _isSaved = false;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _outfit = widget.outfit;
  }

  Future<void> _markAsWorn() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    final result =
        await OutfitWearService.markOutfitAsWorn(_outfit);

    if (!mounted) return;

    String message;

    switch (result) {
      case OutfitWearResult.success:
        message = 'Outfit marked as worn';
        if (widget.onWorn != null) {
          await widget.onWorn!(_outfit);
        }
        break;

      case OutfitWearResult.noItemsFound:
        message = 'No matching wardrobe items found';
        break;

      case OutfitWearResult.error:
        message = 'Something went wrong';
        break;
    }

    AppSnackBar.show(
      context,
      message,
    );

    setState(() {
      isSaving = false;
    });
  }

  Future<void> _shareOutfit() async {
    final success =
        await OutfitShareService.shareOutfit(
      repaintKey,
    );

    if (!mounted || success) return;

    AppSnackBar.show(
      context,
      'Failed to share outfit',
    );
  }

  Future<void> _editOutfit() async {

    final edited =
        await Navigator.push<Outfit>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditOutfitScreen(
          outfit: _outfit,
          wardrobeItems: widget.wardrobeItems,
        ),
      ),
    );

    if (edited == null) return;

    setState(() {
      _outfit = edited;
      _isSaved = false;
    });

    await widget.onUpdate?.call(edited);
  }

  Future<void> _updateRating(
    double rating,
  ) async {

    final updated = _outfit.copyWith(
      rating: rating,
    );

    setState(() {
      _outfit = updated;
      _isSaved = false;
    });

    if (widget.onUpdate != null) {
      await widget.onUpdate!(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_outfit.name),
        actions: [

          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editOutfit,
          ),

          if (widget.onSave != null)
            IconButton(
              icon: Icon(
                _isSaved
                    ? Icons.bookmark
                    : Icons.bookmark_add,
                color: _isSaved ? AppColors.selected : null,
              ),
              onPressed: _isSaved
              ? null
              : () async {
                  await widget.onSave!(_outfit);

                  if (!mounted) return;

                  setState(() {
                    _isSaved = true;
                  });

                  AppSnackBar.show(
                    context,
                    'Outfit saved',
                  );
                },
            ),

          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareOutfit,
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: isSaving
            ? null
            : _markAsWorn,
        icon: isSaving
            ? const SizedBox(
                height: 18,
                width: 18,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.check),
        label: Text(
          isSaving
              ? 'Saving...'
              : 'Worn Today',
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: OutfitShareCard(
                outfit: _outfit,
                repaintKey: repaintKey,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .scaffoldBackgroundColor,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  'Rate this Outfit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                OutfitRatingBar(
                  rating: _outfit.rating,
                  onRatingChanged: _updateRating,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}