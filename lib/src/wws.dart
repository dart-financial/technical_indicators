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
  final int _period;
  double? _previousWWS;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a WWS with the specified [period].
  WWS(this._period) {
    _next = (value) {
      if (_previousWWS == null) {
        _previousWWS = value;
        return value;
      }

      final smoothed = ((_previousWWS! * (_period - 1)) + value) / _period;
      _previousWWS = smoothed;

      return smoothed;
    };

    _current = (_) => _previousWWS;
  }

  /// Computes the next WWS value based on the input value.
  double? next(double value) => _next(value);

  /// Computes the current WWS value without affecting future calculations.
  double? current(double value) => _current(value);
}
