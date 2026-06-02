import 'package:flutter/material.dart';
import 'package:wardrobe_ai/models/outfit.dart';
import 'package:wardrobe_ai/widgets/app_snackbar.dart';
import 'package:wardrobe_ai/widgets/outfit/outfit_share_card.dart';
import 'package:wardrobe_ai/services/outfit/outfit_share_service.dart';
import 'package:wardrobe_ai/services/outfit/outfit_wear_service.dart';

class OutfitDetailScreen extends StatefulWidget {
  final Outfit outfit;

  const OutfitDetailScreen({
    super.key,
    required this.outfit,
  });

  @override
    State<OutfitDetailScreen> createState() =>
        _OutfitDetailScreenState();
  }

class _OutfitDetailScreenState
    extends State<OutfitDetailScreen> {
  final GlobalKey repaintKey = GlobalKey();

  bool isSaving = false;

  Future<void> _markAsWorn() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    final result =
        await OutfitWearService.markOutfitAsWorn(
      widget.outfit,
    );

    if (!mounted) return;

    String message;

    switch (result) {
      case OutfitWearResult.success:
        message = 'Outfit marked as worn';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.outfit.name),
        actions: [
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
      body: Center(
        child: OutfitShareCard(
          outfit: widget.outfit,
          repaintKey: repaintKey,
        ),
      ),
    );
  }
}