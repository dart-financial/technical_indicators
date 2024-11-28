part of '../technical_indicators.dart';

/// **Relative Moving Average (RMA)**
///
/// The Relative Moving Average (RMA) is a type of moving average that assigns
/// more weight to recent data while giving less importance to older data.
/// It is similar to the Exponential Moving Average (EMA) but reacts more slowly
/// to price changes.
///
/// **Formula:**
/// ```
/// RMA = (Previous RMA * (Period - 1) + Current Value) / Period
/// ```
///
/// **Usage:**
/// - RMA is commonly used in trend-following strategies to smooth price fluctuations.
/// - Provides a less reactive but more stable moving average compared to EMA.
///
/// - **`next`:** Computes the next RMA value based on a new input.
/// - **`current`:** Computes a momentary RMA value without modifying the internal state.
class RMA implements MovingAverage {
  late double? Function(double value) _next;
  late double? Function(double value) _current;
  double? _value;

  RMA(int period) {
    final SMA sma = SMA(period);
    final double alpha = 1 / period;

    _next = (value) {
      if (_value == null) {
        _value = sma.next(value);
      } else {
        _value = alpha * value + (1 - alpha) * _value!;

        _current = (value) => alpha * value + (1 - alpha) * _value!;

        _next = (value) {
          _value = _current(value);
          return _value;
        };
      }

      return _value;
    };

    _current = (_) => null;
  }

  @override
  double? next(double value) => _next(value);

  @override
  double? current(double value) => _current(value);
}
