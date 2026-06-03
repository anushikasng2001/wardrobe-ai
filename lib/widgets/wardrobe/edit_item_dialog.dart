import 'package:flutter/material.dart';
import 'package:wardrobe_ai/constants/wardrobe_constants.dart';

Future<Map<String, String>?> showEditItemDialog({
  required BuildContext context,
  required String category,
  required String color,
}) {
  String selectedCategory = category;
  String selectedColor = color;

  return showDialog<Map<String, String>>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  value: selectedCategory,
                  items: WardrobeConstants.categories
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  value: selectedColor,
                  items: WardrobeConstants.colors
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedColor = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    {
                      'category': selectedCategory,
                      'color': selectedColor,
                    },
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}