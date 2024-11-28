import 'package:technical_indicators/technical_indicators.dart';

class AvgChangeProvider {
  final SMMA gain;
  final SMMA loss;
  double? _prev;

  late (double?, double?) Function(double) _next;

  late (double?, double?) Function(double) _current;

  AvgChangeProvider(int period)
      : gain = SMMA(period),
        loss = SMMA(period) {
    calculate(double value) {
      final change = value - _prev!;

      final upAvg = gain.next(change > 0.0 ? change : 0.0);
      final downAvg = loss.next(change < 0.0 ? change : 0.0);

      return (upAvg, downAvg);
    }

    _next = (value) {
      if (_prev == null) {
        _prev = value;

        _next = (value) {
          final result = calculate(value);
          _prev = value;
          return result;
        };
      }

      return const (null, null);
    };

    _current = (value) {
      if (_prev == null) {
        _prev = value;

        _current = calculate;
      }

      return const (null, null);
    };
  }

  (double?, double?) current(double value) => _current(value);

  (double?, double?) next(double value) => _next(value);
}
