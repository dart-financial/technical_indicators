import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> smaValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    smaValues = await TestDataLoader.loadExpectedValues('sma_values.json');
  });

  test('SMA Calculation', () {
    final sma = SMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = smaValues[i];

      final result = sma.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
