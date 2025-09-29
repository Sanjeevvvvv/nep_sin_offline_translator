import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share_plus/share_plus.dart';

class ResultPanel extends StatelessWidget {
  final String ocrText;
  final String translated;

  const ResultPanel({super.key, required this.ocrText, required this.translated});

  void _copy(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    FlutterClipboard.copy(text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
  }

  void _share(String text) {
    if (text.trim().isEmpty) return;
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Detected Text', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(ocrText.isEmpty ? '—' : ocrText),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
              onPressed: () => _copy(context, ocrText),
            ),
            TextButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              onPressed: () => _share(ocrText),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Translation (English)', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(translated.isEmpty ? '—' : translated),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
              onPressed: () => _copy(context, translated),
            ),
            TextButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              onPressed: () => _share(translated),
            ),
          ],
        ),
      ],
    );
  }
}


