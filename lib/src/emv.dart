part of '../technical_indicators.dart';

/// **Ease of Movement Value (EMV)**
///
/// EMV measures how easily prices move based on volume and volatility.
///
/// **Formula:**
/// ```
/// EMV = ((High + Low) - (Prev High + Prev Low)) / Volume
/// ```
class EMV {
  double _prevHigh = 0;
  double _prevLow = 0;

  late double? Function(double high, double low, double volume) _next;
  late double? Function(double high, double low, double volume) _current;

  /// Constructs an EMV indicator.
  EMV() {
    _next = (high, low, volume) {
      if (_prevHigh == 0 && _prevLow == 0) {
        _prevHigh = high;
        _prevLow = low;
        return null;
      }

      final emv = ((high + low) - (_prevHigh + _prevLow)) / volume;

      _prevHigh = high;
      _prevLow = low;

      _current = (high, low, volume) {
        return ((high + low) - (_prevHigh + _prevLow)) / volume;
      };

      return emv;
    };

    _current = (_, __, ___) => null;
  }

  /// Computes the next EMV value.
  double? next(double high, double low, double volume) => _next(high, low, volume);

  /// Computes the current EMV value without affecting future calculations.
  double? current(double high, double low, double volume) => _current(high, low, volume);
}
