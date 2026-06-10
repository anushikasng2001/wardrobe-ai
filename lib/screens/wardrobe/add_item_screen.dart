import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_ai/constants/wardrobe_constants.dart';
import 'package:wardrobe_ai/widgets/add_item/add_item_dropdown.dart';
import 'package:wardrobe_ai/widgets/add_item/selected_images_grid.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];

  String selectedCategory = WardrobeConstants.itemCategories.first;

  String selectedColor = WardrobeConstants.colors.first;

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images) ;
      });
    }
  }

  void _saveItems() {
    if (selectedImages.isEmpty) return;

    Navigator.pop(context, {
      'imagePaths': selectedImages.map((e) => e.path).toList(),
      'category': selectedCategory,
      'color': selectedColor
    });
  }

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image != null) {
      setState(() {
        selectedImages.add(image);
      });
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
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AddItemDropdown(
              label: 'Category',
              value: selectedCategory,
              options: WardrobeConstants.itemCategories,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            AddItemDropdown(
              label: 'Color',
              value: selectedColor,
              options: WardrobeConstants.colors,
              onChanged: (value) {
                setState(() {
                  selectedColor = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SelectedImagesGrid(
                images: selectedImages,
              ),
            ),
            ElevatedButton(
              onPressed:
                  selectedImages.isEmpty
                      ? null
                      : _saveItems,
              child: const Text('Save Items'),
            ),
          ],
        ),
      ),
    );
  }
}
