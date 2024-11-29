import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> emaValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    emaValues = await TestDataLoader.loadExpectedValues('ema_values.json');
  });

  test('EMA Calculation', () {
    final ema = EMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = emaValues[i];

      final result = ema.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
