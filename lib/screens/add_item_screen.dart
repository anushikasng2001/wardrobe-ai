import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];
  String selectedCategory = 'Top';
  String selectedColor = 'Black';

  final List<String> categories = [
    'Top',
    'Bottom',
    'Dress',
    'Shoes',
    'Accessories',
    'Jacket',
  ];

  final List<String> colors = [
    'Black',
    'White',
    'Blue',
    'Red',
    'Green',
    'Beige',
    'Grey',
  ];

  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        selectedImages = images;
      });
    }
  }

  void saveItems() {
    if (selectedImages.isEmpty) return;

    Navigator.pop(context, {
      'imagePaths': selectedImages.map((e) => e.path).toList(),
      'category': selectedCategory,
      'color': selectedColor
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
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.photo_library),
              label: const Text('Select Images'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedColor,
              items: colors
                  .map(
                    (color) => DropdownMenuItem(
                      value: color,
                      child: Text(color),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedColor = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: selectedImages.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return SafeImage(path: selectedImages[index].path,);
                },
              ),
            ),
            ElevatedButton(
              onPressed: saveItems,
              child: const Text('Save Items'),
            ),
          ],
        ),
      ),
    );
  }
}
