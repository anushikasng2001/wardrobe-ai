import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OutfitShareService {
  static Future<bool> shareOutfit(
    GlobalKey repaintKey,
  ) async {
    try {
      final boundary =
          repaintKey.currentContext!
                  .findRenderObject()
              as RenderRepaintBoundary;

      final image =
          await boundary.toImage(
        pixelRatio: 4,
      );

      final byteData =
          await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      final bytes =
          byteData!.buffer.asUint8List();

      final dir =
          await getTemporaryDirectory();

      final file = File(
        '${dir.path}/outfit_instagram.png',
      );

      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'OOTD ✨',
      );

      return true;
    } catch (_) {
      return false;
    }
  }
}