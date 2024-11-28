part of '../technical_indicators.dart';

/// **Momentum Indicator**
///
/// The Momentum indicator measures the rate of price change over a specified period.
/// It helps identify the strength or weakness of a trend.
///
/// **Formula:**
/// ```
/// Momentum = Close - Close (n-periods ago)
/// ```
///
/// **Usage:**
/// - Positive values indicate bullish momentum.
/// - Negative values indicate bearish momentum.
///
/// - **`next`:** Computes the next momentum value based on the closing price.
/// - **`current`:** Computes a momentary value without affecting future calculations.
class Momentum {
  final CircularBuffer<double> _buffer;

  late double? Function(double close) _next;
  late double? Function(double close) _current;

  /// Constructs a Momentum indicator with a specified [period].
  Momentum(int period) : _buffer = CircularBuffer<double>(period) {
    _next = (close) {
      _buffer.push(close);

      if (_buffer.isFull) {
        _next = (close) {
          final oldest = _buffer.push(close)!;
          return close - oldest;
        };

        _current = (close) {
          final oldest = _buffer.peek()!;
          return close - oldest;
        };

        return close - _buffer.peek()!;
      }

      return null;
    };

    _current = (_) => null;
  }

  /// Computes the next Momentum value based on the closing price.
  double? next(double close) => _next(close);

  /// Computes the current Momentum value without affecting calculations.
  double? current(double close) => _current(close);
}
