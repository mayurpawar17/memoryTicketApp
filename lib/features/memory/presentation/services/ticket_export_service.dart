import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/memory.dart';

class TicketExportService {
  /// Rasterizes the widget wrapped in RepaintBoundary to a high-res byte array.
  /// pixelRatio: 4.0 ensures Ultra-HD quality for sharing.
  static Future<Uint8List?> captureTicketImage(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // Use pixelRatio: 4.0 for Ultra-HD resolution
      final ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing ticket image: $e");
      return null;
    }
  }

  /// Exports and shares the ticket as a high-quality PNG image.
  static Future<void> shareAsImage(GlobalKey key, Memory memory) async {
    final bytes = await captureTicketImage(key);
    if (bytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/Ticket_${memory.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(path);
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(path)],
      text: 'Collected a new memory: ${memory.title} 🎟️\nCaptured with Memory Ticket App',
    );
  }
}
