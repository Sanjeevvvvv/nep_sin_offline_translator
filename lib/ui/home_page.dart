import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import '../services/translator_service.dart';
import 'widgets/action_buttons.dart';
import 'widgets/result_panel.dart';
import 'preview_note.dart';

enum SourceLang { nepali, sinhalese }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SourceLang _sourceLang = SourceLang.nepali;
  File? _imageFile;
  String _ocrText = '';
  String _translated = '';
  bool _busy = false;
  final ImagePicker _picker = ImagePicker();
  late final TranslatorService _translator;

  @override
  void initState() {
    super.initState();
    _translator = TranslatorService();
  }

  Future<void> _pickFromCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera);
    if (x != null) setState(() => _imageFile = File(x.path));
  }

  Future<void> _pickFromGallery() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _imageFile = File(x.path));
  }

  Future<void> _translate() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture or select an image.')),
      );
      return;
    }
    setState(() {
      _busy = true;
      _ocrText = '';
      _translated = '';
    });

    try {
      final langCode = _sourceLang == SourceLang.nepali ? 'nep' : 'sin';
      final text = await OcrService.extractText(_imageFile!, langCode);
      if (text.trim().isEmpty) {
        setState(() {
          _busy = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No text detected. Try a clearer photo.')),
        );
        return;
      }
      _ocrText = text;

      final modelId = _sourceLang == SourceLang.nepali
          ? TranslationModelId.neToEn
          : TranslationModelId.siToEn;

      final translated = await _translator.translate(text, modelId);
      setState(() {
        _translated = translated;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _translator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langItems = [
      DropdownMenuItem(value: SourceLang.nepali, child: Text('Nepali → English')),
      DropdownMenuItem(value: SourceLang.sinhalese, child: Text('Sinhalese → English')),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Offline OCR + Translate')),
      body: SafeArea(
        child: Column(
          children: [
            const PreviewNote(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Text('Source Language:'),
                  const SizedBox(width: 12),
                  DropdownButton<SourceLang>(
                    value: _sourceLang,
                    items: langItems,
                    onChanged: (v) => setState(() => _sourceLang = v!),
                  ),
                ],
              ),
            ),
            ActionButtons(
              onCamera: _pickFromCamera,
              onGallery: _pickFromGallery,
              onTranslate: _translate,
              busy: _busy,
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image.file(_imageFile!, height: 140),
              ),
            Expanded(
              child: ResultPanel(
                ocrText: _ocrText,
                translated: _translated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


