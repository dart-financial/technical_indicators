import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> rsiValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    rsiValues = await TestDataLoader.loadExpectedValues('rsi_values.json');
  });

  test('RSI Calculation', () {
    final rsi = RSI(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = rsiValues[i];

      final result = rsi.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
