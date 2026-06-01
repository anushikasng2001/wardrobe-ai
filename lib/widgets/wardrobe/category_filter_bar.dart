import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String category) onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: categories.map((category) {

          final isSelected =
              selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                onCategorySelected(category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}