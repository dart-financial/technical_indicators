import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> smmaValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    smmaValues = await TestDataLoader.loadExpectedValues('smma_values.json');
  });

  test('SMMA Calculation', () {
    final smma = SMMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = smmaValues[i];

      final result = smma.next(close);

      expect(result, expected, reason: 'Mismatch at index $i');
    }
  });
}
