import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> ewmaValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    ewmaValues = await TestDataLoader.loadExpectedValues('ewma_values.json');
  });

  test('EWMA Calculation', () {
    final ewma = EWMA(0.1);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = ewmaValues[i];

      final result = ewma.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
