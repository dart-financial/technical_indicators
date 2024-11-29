import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> atrValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    atrValues = await TestDataLoader.loadExpectedValues('atr_values.json');
  });

  test('ATR Calculation', () {
    final atr = ATR(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final close = ohlcvData[i]['c'];
      final expected = atrValues[i];

      final result = atr.next(high, low, close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
