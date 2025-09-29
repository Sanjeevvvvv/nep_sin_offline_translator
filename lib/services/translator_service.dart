import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:onnxruntime/onnxruntime.dart';
import '../services/tokenizer/sentencepiece_tokenizer.dart';

enum TranslationModelId { neToEn, siToEn }

class TranslatorService {
  OrtSession? _session;
  late SentencePieceTokenizer _tokenizer;
  late Map<String, dynamic> _vocab;
  bool _loadedNe = false;
  bool _loadedSi = false;

  Future<void> _loadModel(TranslationModelId id) async {
    if (id == TranslationModelId.neToEn && _loadedNe) return;
    if (id == TranslationModelId.siToEn && _loadedSi) return;

    _session?.release();

    final basePath = id == TranslationModelId.neToEn
        ? 'assets/models/ne_en'
        : 'assets/models/si_en';

    final modelBytes = await rootBundle.load('$basePath/model.onnx');
    final spmBytes = await rootBundle.load('$basePath/spm.model');
    final vocabJson = await rootBundle.loadString('$basePath/vocab.json');

    _vocab = jsonDecode(vocabJson) as Map<String, dynamic>;
    _tokenizer = SentencePieceTokenizer(
      spmBytes.buffer.asUint8List(),
      _vocab,
    );

    final env = OrtEnv.instance;
    _session = OrtSession.fromBuffer(
      env,
      modelBytes.buffer.asUint8List(),
      sessionOptions: OrtSessionOptions()
        ..setIntraOpNumThreads(1)
        ..setGraphOptimizationLevel(GraphOptimizationLevel.ortEnableAll),
    );

    if (id == TranslationModelId.neToEn) _loadedNe = true;
    if (id == TranslationModelId.siToEn) _loadedSi = true;
  }

  Future<String> translate(String input, TranslationModelId id) async {
    await _loadModel(id);

    final tokens = _tokenizer.encode(input);
    final inputIds = Int32List.fromList(tokens.inputIds);
    final attnMask = Int32List.fromList(List.filled(tokens.inputIds.length, 1));

    final inputs = {
      'input_ids': OrtValueTensor.createTensorFromDataList(inputIds, [1, inputIds.length]),
      'attention_mask':
          OrtValueTensor.createTensorFromDataList(attnMask, [1, attnMask.length]),
    };

    final outputs = _session!.run(inputs);
    // Assuming exported model outputs decoded sequences directly for mobile usage
    final sequences = outputs.first.value as List<int>;
    final text = _tokenizer.decode(sequences);

    for (final v in inputs.values) {
      v.release();
    }
    for (final o in outputs) {
      o.release();
    }
    return text;
  }

  void dispose() {
    _session?.release();
  }
}


