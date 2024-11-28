part of '../technical_indicators.dart';

/// **Smoothed Moving Average (SMMA)**
///
/// The Smoothed Moving Average (SMMA) is a moving average that smooths out price fluctuations
/// over a specified period by giving equal weight to all data points in the calculation.
/// It is slower to react to price changes compared to other moving averages like EMA.
///
/// **Formula:**
/// ```
/// SMMA = (Previous SMMA * (Period - 1) + Current Value) / Period
/// ```
///
/// **Usage:**
/// - Filters out market noise to provide a clearer trend direction.
/// - Suitable for long-term trend analysis due to its smoothing nature.
///
/// - **`next`:** Computes the next SMMA value based on a new input.
/// - **`current`:** Computes a momentary SMMA value without modifying the internal state.
class SMMA implements MovingAverage {
  final int period;
  final CircularBuffer buffer;

  double _sum = 0;
  double _avg = 0;
  int _count = 0;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a Smoothed Moving Average with a specified [period].
  SMMA(this.period) : buffer = CircularBuffer(period) {
    _next = (value) {
      _sum += value;
      _count++;

      if (_count == period) {
        _avg = _sum / period;
        _next = (value) {
          return _avg = (_avg * (period - 1) + value) / period;
        };
        _current = (value) {
          return (_avg * (period - 1) + value) / period;
        };
        return _avg;
      }

      return null;
    };

    _current = (_) => null;
  }

  @override
  double? next(double value) => _next(value);

  @override
  double? current(double value) => _current(value);
}
