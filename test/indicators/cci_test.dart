import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> cciValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    cciValues = await TestDataLoader.loadExpectedValues('cci_values.json');
  });

  test('CCI Calculation', () {
    final cci = CCI(20);

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final close = ohlcvData[i]['c'];
      final expected = cciValues[i];

      final result = cci.next(high, low, close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
