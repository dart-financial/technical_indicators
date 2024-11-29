import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> wwsValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    wwsValues = await TestDataLoader.loadExpectedValues('wws_values.json');
  });

  test('WWS Calculation', () {
    final wws = WWS(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = wwsValues[i];

      final result = wws.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
