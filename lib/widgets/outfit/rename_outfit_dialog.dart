import 'package:flutter/material.dart';

Future<String?> showRenameOutfitDialog(
  BuildContext context,
  String currentName,
) {
  final controller =
      TextEditingController(text: currentName);

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rename Outfit'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Outfit name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              controller.text.trim(),
            );
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}