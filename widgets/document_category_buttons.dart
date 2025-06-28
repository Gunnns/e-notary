import 'package:flutter/material.dart';

class DocumentCategoryButtons extends StatelessWidget {
  final Function(String)? onCategorySelected;
  final String? selectedCategory;

  const DocumentCategoryButtons({
    super.key,
    this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Repertorium',
      'Akta',
      'Legalisasi',
      'Waarmeking',
      'Wasiat',
      'Waris',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return FilterChip(
          label: Text(category),
          selected: selectedCategory == category,
          onSelected: (selected) {
            if (onCategorySelected != null) {
              onCategorySelected!(selected ? category : '');
            }
          },
        );
      }).toList(),
    );
  }
}