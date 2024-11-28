import 'dart:convert';
import 'dart:io';

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;

  setUp(() async {
    final ohlcvFile = File('test/ohlcv.json');
    ohlcvData = List<Map<String, dynamic>>.from(jsonDecode(await ohlcvFile.readAsString()));
  });

  test('ATR Calculation', () async {
    final rmaFile = File('test/data/atr_values.json');

    final rmaValues = jsonDecode(await rmaFile.readAsString());

    final rma = ATR(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final close = ohlcvData[i]['c'];
      final expected = rmaValues[i];

      final result = rma.next(high, low, close);

      expect(expected, result, reason: 'Mismatch at index $i');
    }
  });

  test('SMA Calculation', () async {
    final rmaFile = File('test/data/sma_values.json');

    final rmaValues = jsonDecode(await rmaFile.readAsString());

    final rma = SMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = rmaValues[i];

      final result = rma.next(close);

      expect(expected, result, reason: 'Mismatch at index $i');
    }
  });
  test('RMA Calculation', () async {
    final rmaFile = File('test/data/rma_values.json');

    final rmaValues = jsonDecode(await rmaFile.readAsString());

    final rma = RMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = rmaValues[i];

      final result = rma.next(close);

      expect(expected, result, reason: 'Mismatch at index $i');
    }
  });
  test('ROC Calculation', () async {
    final rmaFile = File('test/data/roc_values.json');

    final rmaValues = jsonDecode(await rmaFile.readAsString());

    final rma = ROC(10);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = rmaValues[i];

      final result = rma.next(close);

      expect(expected, result, reason: 'Mismatch at index $i');
    }
  });
}
