import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> chaikinValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    chaikinValues = await TestDataLoader.loadExpectedValues('chaikin_values.json');
  });

  test('ChaikinOscillator Calculation', () {
    final chaikin = ChaikinOscillator(3, 10);

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final close = ohlcvData[i]['c'];
      final volume = ohlcvData[i]['v'];
      final expected = chaikinValues[i];

      final result = chaikin.next(high, low, close, double.parse("$volume"));

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
