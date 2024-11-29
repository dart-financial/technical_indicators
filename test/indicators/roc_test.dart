import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> rocValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    rocValues = await TestDataLoader.loadExpectedValues('roc_values.json');
  });

  test('ROC Calculation', () {
    final roc = ROC(10);

    for (int i = 0; i < ohlcvData.length; i++) {
      final close = ohlcvData[i]['c'];
      final expected = rocValues[i];

      final result = roc.next(close);

      expect(expected, result, reason: 'Mismatch at index $i');
    }
  });
}
