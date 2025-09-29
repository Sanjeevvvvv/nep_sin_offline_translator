import 'dart:typed_data';

class Encoded {
  final List<int> inputIds;
  Encoded(this.inputIds);
}

class SentencePieceTokenizer {
  final Uint8List spModel;
  final Map<String, dynamic> vocab;
  late final Map<String, int> tokenToId;
  late final Map<int, String> idToToken;
  final int bosId;
  final int eosId;

  SentencePieceTokenizer(this.spModel, this.vocab)
      : bosId = (vocab['special_tokens']?['bos'] ?? 0) as int,
        eosId = (vocab['special_tokens']?['eos'] ?? 2) as int {
    final Map<String, dynamic> t2i = Map<String, dynamic>.from(vocab['token_to_id']);
    tokenToId = t2i.map((k, v) => MapEntry(k, v as int));
    final Map<String, dynamic> i2t = Map<String, dynamic>.from(vocab['id_to_token']);
    idToToken = i2t.map((k, v) => MapEntry(int.parse(k), v as String));
  }

  Encoded encode(String text) {
    final tokens = _whitespaceApprox(text);
    final ids = <int>[bosId];
    for (final t in tokens) {
      final id = tokenToId[t] ?? tokenToId['<unk>'] ?? 3;
      ids.add(id);
    }
    ids.add(eosId);
    return Encoded(ids);
  }

  String decode(List<int> ids) {
    final buf = StringBuffer();
    for (final id in ids) {
      if (id == bosId || id == eosId) continue;
      final tok = idToToken[id] ?? '';
      if (tok.startsWith('▁')) {
        buf.write(' ');
        buf.write(tok.substring(1));
      } else {
        buf.write(tok);
      }
    }
    return buf.toString().trim();
  }

  List<String> _whitespaceApprox(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    return words.map((w) => '▁$w').toList();
  }
}


