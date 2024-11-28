part of '../technical_indicators.dart';

/// **Linearly Weighted Moving Average (LWMA)**
///
/// LWMA is a moving average where recent values are given more weight in a linear fashion.
///
/// **Formula:**
/// ```
/// LWMA = (Sum(Price * Weight)) / (Sum(Weight))
/// ```
class LWMA implements MovingAverage {
  final CircularBuffer<double> _buffer;
  final int _period;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a LWMA with the specified [period].
  LWMA(this._period) : _buffer = CircularBuffer(_period) {
    _next = (value) {
      _buffer.push(value);

      if (_buffer.isFull) {
        final weights = List.generate(_period, (i) => i + 1);
        final values = _buffer.toList();

        double weightedSum = 0;
        double weightSum = 0;

        for (int i = 0; i < _period; i++) {
          weightedSum += values[i]! * weights[i];
          weightSum += weights[i];
        }

        return weightedSum / weightSum;
      }

      return null;
    };

    _current = (_) => null;
  }

  /// Computes the next LWMA value based on the input value.
  @override
  double? next(double value) => _next(value);

  /// Computes the current LWMA value without affecting future calculations.
  @override
  double? current(double value) => _current(value);
}
