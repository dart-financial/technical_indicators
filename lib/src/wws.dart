part of '../technical_indicators.dart';

/// **Welles Wilder's Smoothing Average (WWS)**
///
/// WWS is a smoothed average commonly used in ATR and ADX calculations.
///
/// **Formula:**
/// ```
/// WWS_t = ((Previous WWS * (n - 1)) + Current Value) / n
/// ```
class WWS {
  double _prevValue = 0;
  int _sumCount = 1;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a WWS with the specified [period].
  WWS(final int period) {
    _next = (value) {
      if (_sumCount == period) {
        _prevValue += value;
        _sumCount++;

        _next = (value) {
          return (_prevValue = _prevValue - _prevValue / period + value);
        };

        _current = (value) {
          return _prevValue - _prevValue / period + value;
        };

        return _prevValue;
      }

      _prevValue += value;
      _sumCount++;

      return null;
    };

    _current = (_) => null;
  }

  /// Computes the next WWS value based on the input value.
  double? next(double value) => _next(value);

  /// Computes the current WWS value without affecting future calculations.
  double? current(double value) => _current(value);
}
