import 'package:flutter/material.dart';

void showDeleteItemSheet({
  required BuildContext context,
  required VoidCallback onDelete,
}) {

  showModalBottomSheet(
    context: context,

    builder: (_) {

      return SafeArea(
        child: Wrap(
          children: [

            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),

              title: const Text(
                'Delete Item',
              ),

              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),

            ListTile(
              leading: const Icon(Icons.close),

              title: const Text(
                'Cancel',
              ),

              onTap: () =>
                  Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}