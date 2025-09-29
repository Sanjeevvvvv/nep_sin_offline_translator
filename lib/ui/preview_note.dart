import 'package:flutter/material.dart';

class PreviewNote extends StatelessWidget {
  const PreviewNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        border: Border.all(color: Colors.amber.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Preview mode: placeholder assets are included so the UI runs.\n'
        'Add real tessdata and ONNX models in assets/ to enable OCR and translation.',
      ),
    );
  }
}


