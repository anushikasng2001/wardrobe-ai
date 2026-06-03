import 'package:flutter/material.dart';

class OutfitRatingBar extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;

  const OutfitRatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) {
          final star = index + 1;

          return IconButton(
            onPressed: () =>
                onRatingChanged(star.toDouble()),
            icon: Icon(
              rating >= star
                  ? Icons.star
                  : Icons.star_border,
              color: Colors.amber,
            ),
          );
        },
      ),
    );
  }
}