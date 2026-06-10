import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_ai/constants/app_colors.dart';
import 'package:wardrobe_ai/constants/wardrobe_constants.dart';
import 'package:wardrobe_ai/models/pending_wardrobe_image.dart';
import 'package:wardrobe_ai/services/ai/color_detection_service.dart';
import 'package:wardrobe_ai/services/image/image_service.dart';
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
  String selectedColor = WardrobeConstants.colors.first;
  bool _isProcessing = false;
  bool _isDetectingColors = false;

  Future<void> _pickImages() async {
    final images =
        await ImageService.pickMultipleFromGallery();

    if (images.isEmpty) return;

    setState(() {
      _isDetectingColors = true;
    });

    final pendingImages = await Future.wait(
      images.map((image) async {
        final color =
            await ColorDetectionService.detectColor(
          image.path,
        );

        return PendingWardrobeImage(
          image: image,
          detectedColor: color,
        );
      }),
    );

    if (!mounted) return;

    setState(() {
      _isDetectingColors = false;
      selectedImages.addAll(pendingImages);
    });
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
            'category': selectedCategory,
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
    final image =
        await ImageService.pickFromCamera();

    if (image == null) return;

    setState(() {
      _isDetectingColors = true;
    });

    final color =
        await ColorDetectionService.detectColor(
      image.path,
    );

    if (!mounted) return;

    setState(() {
      _isDetectingColors = false;
      selectedImages.add(
        PendingWardrobeImage(
          image: XFile(image.path),
          detectedColor: color,
        ),
      );
    });
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
                    onPressed: (_isProcessing || _isDetectingColors) ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isProcessing || _isDetectingColors) ? null : _pickImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            if (_isDetectingColors) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
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
              options: WardrobeConstants.colors,
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

                if (_isDetectingColors)
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
