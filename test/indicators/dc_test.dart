import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import '../utils/test_data_loader.dart';

void main() {
  late List<Map<String, dynamic>> ohlcvData;
  late List<dynamic> dcValues;

  setUp(() async {
    ohlcvData = await TestDataLoader.loadOhlcv();
    dcValues = await TestDataLoader.loadExpectedValues('dc_values.json');
  });

  test('DC Calculation', () {
    final dc = DonchianChannels(20);

    for (int i = 0; i < ohlcvData.length; i++) {
      final high = ohlcvData[i]['h'];
      final low = ohlcvData[i]['l'];
      final expected = dcValues[i];

      final result = dc.next(high, low);

      expect(result?.upper, closeTo(expected?['upper'], 0.1), reason: 'Mismatch at upper index $i');
      expect(result?.middle, closeTo(expected?['middle'], 0.1), reason: 'Mismatch at middle index $i');
      expect(result?.lower, closeTo(expected?['lower'], 0.1), reason: 'Mismatch at lower index $i');
    }
  });
}
