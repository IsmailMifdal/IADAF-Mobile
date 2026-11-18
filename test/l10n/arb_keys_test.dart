import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> keysOf(String lang) {
  final arb = jsonDecode(
    File('lib/l10n/app_$lang.arb').readAsStringSync(),
  ) as Map<String, dynamic>;
  return arb.keys.where((key) => !key.startsWith('@')).toSet();
}

void main() {
  test('every language has the same keys as French', () {
    final french = keysOf('fr');
    for (final lang in ['en', 'ar', 'es']) {
      expect(keysOf(lang), french, reason: 'app_$lang.arb');
    }
  });
}
