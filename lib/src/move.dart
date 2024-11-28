part of '../technical_indicators.dart';

class Move {
  final CircularBuffer changes;
  final int period;
  double? _prevPrice;
  double _value = 0;

  Move(this.period) : changes = CircularBuffer(period);

  double? next(double close) {
    if (_prevPrice != null) {
      final change = percentChange(close, _prevPrice!);
      calculate(change);
      _prevPrice = close;

      return _value;
    }

    _prevPrice = close;
    return null;
  }

  double? calculate(double change) {
    try {
      _value += change;
      _value -= changes.push(change)!;

      return _value;
    } catch (e) {
      return null;
    }
  }
}
