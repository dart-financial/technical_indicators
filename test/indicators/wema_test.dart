import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> wemaValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    wemaValues = await TestDataLoader.loadExpectedValues('wema_values.json');
  });

  test('WEMA Calculation', () {
    final wema = WEMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = wemaValues[i];

      final result = wema.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
