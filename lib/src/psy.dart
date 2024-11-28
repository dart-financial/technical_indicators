part of '../technical_indicators.dart';

/// **Psychological Line (PSY)**
///
/// PSY measures the percentage of candles with a close above the open price
/// over a specified period.
///
/// **Formula:**
/// ```
/// PSY = (Number of Up Days / Total Periods) * 100
/// ```
class PSY {
  final CircularBuffer<bool> _buffer;

  late double? Function(double open, double close) _next;
  late double? Function(double open, double close) _current;

  /// Constructs a PSY indicator with the specified [period].
  PSY(int period) : _buffer = CircularBuffer<bool>(period) {
    _next = (open, close) {
      _buffer.push(close > open);

      if (_buffer.isFull) {
        final upDays = _buffer.toList().where((v) => v!).length;
        return (upDays / _buffer.capacity) * 100;
      }

      return null;
    };

    _current = (open, close) => null;
  }

  /// Computes the next PSY value based on open and close prices.
  double? next(double open, double close) => _next(open, close);

  /// Computes a momentary PSY value without affecting future calculations.
  double? current(double open, double close) => _current(open, close);
}
