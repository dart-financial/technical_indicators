import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> rmaValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    rmaValues = await TestDataLoader.loadExpectedValues('rma_values.json');
  });

  test('RMA Calculation', () {
    final rma = RMA(14);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = rmaValues[i];

      final result = rma.next(close);

      expect(expected, result, reason: 'Mismatch at index $i');
    }
  });
}
