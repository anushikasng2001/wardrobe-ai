import 'package:flutter/material.dart';

class GenerateOutfitDialog extends StatefulWidget {
  final Function(
    String occasion,
    String weather,
  ) onGenerate;

  const GenerateOutfitDialog({
    super.key,
    required this.onGenerate,
  });

  @override
  State<GenerateOutfitDialog> createState() =>
      _GenerateOutfitDialogState();
}

class _GenerateOutfitDialogState
    extends State<GenerateOutfitDialog> {

  String selectedOccasion = 'Casual';
  String selectedWeather = 'Hot';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate Outfit'),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          DropdownButton<String>(
            value: selectedOccasion,
            isExpanded: true,
            items: [
              'Casual',
              'Office',
              'Party',
              'Gym',
            ]
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedOccasion = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          DropdownButton<String>(
            value: selectedWeather,
            isExpanded: true,
            items: [
              'Hot',
              'Cold',
              'Rainy',
            ]
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedWeather = value!;
              });
            },
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);

            widget.onGenerate(
              selectedOccasion,
              selectedWeather,
            );
          },
          child: const Text('Generate'),
        ),
      ],
    );
  }
}