import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> acValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    acValues = await TestDataLoader.loadExpectedValues('ac_values.json');
  });

  test('AC Calculation', () {
    final ac = AC();

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final expected = acValues[i];

      final result = ac.next(high, low);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
