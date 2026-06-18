import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wardrobe_ai/constants/gemini_clothing_detection_prompt.dart';

class GeminiClothingService {

  static const _apiKey = 'AIzaSyCvXVl4HsAK9QI1X9UX2-OyZhFYeaYIu_c';

  static Future<List<Map<String, dynamic>>> detectItems(
    String imagePath,
  ) async {

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );

    final imageBytes =
        await File(imagePath).readAsBytes();

    final prompt = TextPart(GeminiClothingDetectionPrompt.prompt);

    final response =
        await model.generateContent([
      Content.multi([
        prompt,
        DataPart(
          'image/jpeg',
          imageBytes,
        ),
      ])
    ]);

    final text =
        response.text ?? '';

    final cleanedText = _extractJson(
      response.text ?? '',
    );

    final json = jsonDecode(cleanedText);

    return List<Map<String, dynamic>>.from(
      json['items'],
    );
  }

  static String _extractJson(String text) {
    final match = RegExp(
      r'\{[\s\S]*\}',
    ).firstMatch(text);

    if (match == null) {
      throw Exception('No JSON found');
    }

    return match.group(0)!;
  }
}