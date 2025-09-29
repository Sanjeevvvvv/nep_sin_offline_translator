import 'dart:io';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:path_provider/path_provider.dart';

class OcrService {
  static Future<String> extractText(File imageFile, String langCode) async {
    final dataPath = await _ensureTessdataPresent();
    final text = await FlutterTesseractOcr.extractText(
      imageFile.path,
      language: '$langCode+eng',
      args: {
        'psm': '3',
        'oem': '1',
      },
      tessdata: dataPath,
    );
    return text;
  }

  static Future<String> _ensureTessdataPresent() async {
    final appDir = await getApplicationSupportDirectory();
    final tessDir = Directory('${appDir.path}/tessdata');
    if (!await tessDir.exists()) {
      await tessDir.create(recursive: true);
    }
    return tessDir.path;
  }
}


