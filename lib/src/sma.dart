part of '../technical_indicators.dart';

/// **Simple Moving Average (SMA)**
///
/// The Simple Moving Average (SMA) is a basic moving average calculated
/// by summing up the values of a specified period and dividing by the
/// number of periods.
///
/// **Formula:**
/// ```
/// SMA = Σ(Values) / Period
/// ```
///
/// **Usage:**
/// - Used to smooth out price data to identify trends.
/// - SMA reacts more slowly to price changes compared to other averages like EMA.
///
/// - **`next`:** Computes the next SMA value based on a new input.
/// - **`current`:** Computes a momentary SMA value without modifying internal state.
class SMA implements MovingAverage {
  final CircularBuffer _buffer;

  double _sum = 0;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a Simple Moving Average with a specified [period].
  SMA(int period) : _buffer = CircularBuffer(period) {
    _next = (value) {
      _buffer.push(value);
      _sum += value;

      if (_buffer.isFull) {
        final sma = _sum / _buffer.capacity;

        _current = (value) {
          return (_sum - _buffer.peek()! + value) / _buffer.capacity;
        };

        _next = (value) {
          _sum = _sum - _buffer.push(value)! + value;
          return _sum / _buffer.capacity;
        };

        return sma;
      }

      return null;
    };

    _current = (_) => null;
  }

  int get period => _buffer.capacity;

  @override
  double? next(double value) => _next(value);

  @override
  double? current(double value) => _current(value);
}
