import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onTranslate;
  final bool busy;

  const ActionButtons({
    super.key,
    required this.onCamera,
    required this.onGallery,
    required this.onTranslate,
    required this.busy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  onPressed: busy ? null : onCamera,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Image'),
                  onPressed: busy ? null : onGallery,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: busy
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.translate),
              label: Text(busy ? 'Translating...' : 'Translate'),
              onPressed: busy ? null : onTranslate,
            ),
          ),
        ],
      ),
    );
  }
}


