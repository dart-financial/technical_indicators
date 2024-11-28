part of '../technical_indicators.dart';

/// **Energy Index (CR)**
///
/// Measures the relative strength of the current price against a previous range of prices.
///
/// **Formula:**
/// ```
/// CR = ((Close - Lowest Low) / (Highest High - Lowest Low)) * 100
/// ```
class CR {
  final MaxProvider _max;
  final MinProvider _min;

  late double? Function(double high, double low, double close) _next;
  late double? Function(double high, double low, double close) _current;

  /// Constructs an Energy Index with the specified [period].
  CR({int period = 14})
      : _max = MaxProvider(period),
        _min = MinProvider(period) {
    _next = (high, low, close) {
      final highestHigh = _max.next(high);
      final lowestLow = _min.next(low);

      if (!_max.isFull || !_min.isFull) {
        return null;
      }

      _current = (high, low, close) {
        final highestHigh = _max.current(high);
        final lowestLow = _min.current(low);

        return ((close - lowestLow) / (highestHigh - lowestLow)) * 100;
      };

      return ((close - lowestLow) / (highestHigh - lowestLow)) * 100;
    };

    _current = (_, __, ___) => null;
  }

  /// Computes the next CR value.
  double? next(double high, double low, double close) => _next(high, low, close);

  /// Computes the current CR value without affecting future calculations.
  double? current(double high, double low, double close) => _current(high, low, close);
}
