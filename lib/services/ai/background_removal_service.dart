import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

class BackgroundRemovalService {
  static const String apiKey =
      '62coBcvsFnBAnS1KmPKdRsDs';

  static Future<File?> removeBackground(
      String imagePath) async {

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.remove.bg/v1.0/removebg',
      ),
    );

    request.headers['X-Api-Key'] = apiKey;

    request.files.add(
      await http.MultipartFile.fromPath(
        'image_file',
        imagePath,
      ),
    );

    request.fields['size'] = 'auto';

    final response =
        await request.send();

    if (response.statusCode != 200) {
      return null;
    }

    final bytes =
        await response.stream.toBytes();

    final output =
        File('${imagePath}_clean.png');

    await output.writeAsBytes(bytes);

    return output;
  }
}