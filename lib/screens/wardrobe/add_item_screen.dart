import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_ai/constants/wardrobe_constants.dart';
import 'package:wardrobe_ai/models/pending_wardrobe_image.dart';
import 'package:wardrobe_ai/services/image/garment_extraction_service.dart';
import 'package:wardrobe_ai/services/image/image_service.dart';
import 'package:wardrobe_ai/services/ai/gemini_clothing_service.dart';
import 'package:wardrobe_ai/widgets/add_item/add_item_dropdown.dart';
import 'package:wardrobe_ai/widgets/add_item/selected_images_grid.dart';
import 'package:wardrobe_ai/services/image/image_processing_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  List<PendingWardrobeImage> selectedImages = [];
  String selectedCategory = WardrobeConstants.itemCategories.first;
  String selectedColor = WardrobeConstants.itemColors.first;
  bool _isProcessing = false;
  bool _isAnalyzingImages  = false;
  static const _minConfidence = 0.75;

  List<Map<String, dynamic>> _filterItems(
    List<Map<String, dynamic>> items,
  ) {
    items.sort(
      (a, b) => (
        (b['confidence'] ?? 0) as num
      ).compareTo(
        (a['confidence'] ?? 0) as num,
      ),
    );

    return items.where((item) {
      final confidence =
          (item['confidence'] as num?)
              ?.toDouble() ??
          0.0;

      return confidence >= _minConfidence;
    }).toList();
  }

  Future<List<PendingWardrobeImage>>
      _buildPendingImages(
    XFile image,
    List<Map<String, dynamic>> detectedItems,
  ) async {
    final filteredItems =
        _filterItems(detectedItems);

    if (filteredItems.isEmpty) {
      return [
        PendingWardrobeImage(
          image: image,
          detectedColor: 'Unknown',
          detectedCategory: 'Unknown',
          confidence: 0,
        ),
      ];
    }

    final results = <PendingWardrobeImage>[];

    for (final item in filteredItems) {
      final extractedFile =
          await GarmentExtractionService
              .extractGarment(
        imagePath: image.path,
        category:
            item['category'] ?? 'Unknown',
        subCategory:
            item['subcategory'],
      );

      results.add(
        PendingWardrobeImage(
          image: XFile(extractedFile.path),
          detectedColor:
              item['color'] ?? 'Unknown',
          detectedCategory:
              item['category'] ?? 'Unknown',
          detectedSubCategory:
              item['subcategory'],
          confidence:
              (item['confidence'] as num?)
                  ?.toDouble() ??
              0.0,
        ),
      );
    }

    return results;
  }

  Future<void> _pickImages() async {
    final images =
        await ImageService.pickMultipleFromGallery();

    if (images.isEmpty) return;

    setState(() {
      _isAnalyzingImages = true;
    });

    try {
      final List<PendingWardrobeImage> pendingImages = [];

      for (final image in images) {
        final detectedItems =
            await GeminiClothingService.detectItems(
          image.path,
        );

        final pending =
            await _buildPendingImages(
              image,
              detectedItems,
            );

        pendingImages.addAll(pending);
      }

      if (!mounted) return;

      setState(() {
        selectedImages.addAll(pendingImages);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzingImages = false;
        });
      }
    }
  }

  Future<void> _saveItems() async {
    if (selectedImages.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final processedPaths = <String>[];

      for (final image in selectedImages) {
        final processed =
            await ImageProcessingService.processImage(
          image.image.path,
        );

        processedPaths.add(processed.path);
      }

      if (!mounted) return;

      Navigator.pop(context, {
        'items': selectedImages.asMap().entries.map((entry) {
          return {
            'imagePath': processedPaths[entry.key],
            'color': selectedColor == 'Auto Detect'
              ? entry.value.detectedColor
              : selectedColor,
            'category': selectedCategory == 'Auto Detect'
              ? entry.value.detectedCategory
              : selectedCategory,
            'subcategory': entry.value.detectedSubCategory,
            'confidence': entry.value.confidence,
          };
        }).toList(),
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    final image = await ImageService.pickFromCamera();

    if (image == null) return;

    setState(() {
      _isAnalyzingImages = true;
    });

    try {
      final detectedItems =
          await GeminiClothingService.detectItems(
        image.path,
      );

      if (!mounted) return;

      final pendingImages =
          await _buildPendingImages(
            XFile(image.path),
            detectedItems,
          );

      if (!mounted) return;

      setState(() {
        selectedImages.addAll(pendingImages);
      });

    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzingImages = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Items')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isProcessing || _isAnalyzingImages) ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isProcessing || _isAnalyzingImages) ? null : _pickImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            if (_isAnalyzingImages) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              const Text(
                'Detecting category and color...',
              ),
            ],
            const SizedBox(height: 12),
            AddItemDropdown(
              label: 'Category',
              value: selectedCategory,
              options: WardrobeConstants.itemCategories,
              onChanged: _isProcessing
                ? null
                : (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
            ),
            const SizedBox(height: 12),
            AddItemDropdown(
              label: 'Override Color',
              value: selectedColor,
              options: WardrobeConstants.itemColors,
              onChanged: _isProcessing
                ? null
                : (value) {
                    setState(() {
                      selectedColor = value!;
                    });
                  },
            ),        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedImages.length} item(s)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                if (_isAnalyzingImages)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SelectedImagesGrid(
                images: selectedImages,
              ),
            ),
            ElevatedButton(
              onPressed: selectedImages.isEmpty || _isProcessing
                  ? null
                  : _saveItems,
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save Items'),
            )
          ],
        ),
      ),
    );
  }
}
