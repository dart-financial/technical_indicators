part of '../technical_indicators.dart';

/// An exponential moving average (EMA) is a type of moving average (MA)
/// that places a greater weight and significance on the most recent data points.
/// The exponential moving average is also referred to as the exponentially weighted moving average.
/// An exponentially weighted moving average reacts more significantly to recent price changes
/// than a simple moving average (SMA), which applies an equal weight to all observations in the period.
class EMA implements MovingAverage {
  late double? Function(double value) _next;
  late double? Function(double value) _current;

  double? _value;

  EMA(int period) {
    final SMA sma = SMA(period);
    final double smooth = 2 / (period + 1);

    _next = (value) {
      _value = sma.next(value);
      if (_value != null) {
        _current = (value) {
          return (value - _value!) * smooth + _value!;
        };

        _next = (value) {
          _value = _current(value);
          return _value;
        };
        return _value;
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
