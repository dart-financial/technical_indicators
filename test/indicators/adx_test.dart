import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> adxValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    adxValues = await TestDataLoader.loadExpectedValues('adx_values.json');
  });

  test('ADX Calculation', () {
    final adx = ADX(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final close = ohlcvData[i]['c'];
      final expected = adxValues[i];

      final result = adx.next(high, low, close);

      expect(result?['adx'], expected?['adx'], reason: 'Mismatch at index $i');
      expect(result?['mdi'], expected?['mdi'], reason: 'Mismatch at index $i');
      expect(result?['pdi'], expected?['pdi'], reason: 'Mismatch at index $i');
    }
  });
}
