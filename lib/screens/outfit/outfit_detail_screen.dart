import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_ai/models/wardrobe_item.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

import '../../models/outfit.dart';
import 'package:flutter/rendering.dart';

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

  class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
    bool isSaving = false;

  final GlobalKey repaintKey = GlobalKey();

  Future<void> markOutfitAsWorn(BuildContext context) async {

    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {

      final prefs = await SharedPreferences.getInstance();

      final data = prefs.getString('wardrobe_items');

      if (data == null) {

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No wardrobe data found'),
          ),
        );

        return;
      }

      List<WardrobeItem> items = WardrobeItem.decode(data);

      final now = DateTime.now();

      bool updated = false;

      items = items.map((item) {

        if (widget.outfit.imagePaths.contains(item.imagePath)) {

          updated = true;

          return item.copyWith(
            wearCount: item.wearCount + 1,
            lastWorn: now,
          );
        }

        return item;

      }).toList();

      if (!updated) {

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No matching wardrobe items found'),
          ),
        );

        return;
      }

      await prefs.setString(
        'wardrobe_items',
        WardrobeItem.encode(items),
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Outfit marked as worn'),
        ),
      );

    } catch (e) {

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _shareOutfit(BuildContext context) async {
    try {
      final boundary =
          repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(
        pixelRatio: 4,
      );
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/outfit_instagram.png');

      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'OOTD ✨',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share outfit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.outfit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareOutfit(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isSaving
            ? null
            : () => markOutfitAsWorn(context),

        icon: isSaving
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.check),

        label: Text(
          isSaving ? 'Saving...' : 'Worn Today',
        ),
      ),
      body: Center(
        child: RepaintBoundary(
          key: repaintKey,
          child: Container(
            width: 1080,
            height: 1080,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF8F6F2),
                  Color(0xFFE8E1D9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      widget.outfit.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Styled with Wardrobe AI',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.outfit.imagePaths.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: SafeImage(path: widget.outfit.imagePaths[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
