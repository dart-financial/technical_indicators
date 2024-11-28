part of '../technical_indicators.dart';

/// **Weighted Moving Average (WMA)**
///
/// The Weighted Moving Average (WMA) is a type of moving average that assigns more
/// weight to recent data points, making it more responsive to recent price changes.
/// Unlike the Simple Moving Average (SMA), the WMA accounts for the order of values
/// within the period.
///
/// **Formula:**
/// ```
/// WMA = Σ (Value[i] * Weight[i]) / Σ Weight
/// ```
///
/// **Usage:**
/// - WMA is commonly used to reduce lag in trend-following indicators.
/// - It is more sensitive to recent price changes compared to SMA.
///
/// - **`next`:** Computes the next WMA value based on new input.
/// - **`current`:** Computes a momentary WMA value without affecting internal state.
class WMA {
  final int period;
  final double _denominator;
  final CircularBuffer<double> _buffer;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a Weighted Moving Average with a specified [period].
  WMA({required this.period})
      : _buffer = CircularBuffer(period),
        _denominator = (period * (period + 1)) / 2 {
    double calculate([List<double?>? tempBuffer]) {
      double result = 0;
      tempBuffer ??= _buffer.toList();

      for (int i = 0; i < tempBuffer.length; i++) {
        result += (tempBuffer[i]! * (i + 1)) / _denominator;
      }
      return result;
    }

    _next = (value) {
      _buffer.push(value);

      if (_buffer.isFull) {
        _next = (value) {
          _buffer.push(value);
          return calculate();
        };

        _current = (value) {
          final tempBuffer = _buffer.toList();
          tempBuffer[_buffer.length - 1] = value;
          return calculate(tempBuffer);
        };
      }

      return null;
    };

    _current = (_) => null;
  }

  /// Computes the next WMA value for a closed input.
  double? next(double value) => _next(value);

  /// Computes a momentary WMA value without modifying internal state.
  double? current(double value) => _current(value);
}
