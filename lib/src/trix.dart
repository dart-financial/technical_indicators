part of '../technical_indicators.dart';

/// **Triple Exponential Average (TRIX)**
///
/// TRIX is a momentum oscillator that measures the rate of change of a triple exponential moving average.
///
/// **Formula:**
/// ```
/// TRIX = ((EMA_3 / EMA_3(n-1)) - 1) * 100
/// ```
class TRIX {
  final EMA _ema1;
  final EMA _ema2;
  final EMA _ema3;

  double? _previousTrix;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a TRIX indicator with the specified [period].
  TRIX(int period)
      : _ema1 = EMA(period),
        _ema2 = EMA(period),
        _ema3 = EMA(period) {
    _next = (value) {
      final ema1 = _ema1.next(value);
      if (ema1 == null) return null;

      final ema2 = _ema2.next(ema1);
      if (ema2 == null) return null;

      final ema3 = _ema3.next(ema2);
      if (ema3 == null) return null;

      if (_previousTrix == null) {
        _previousTrix = ema3;
        return null;
      }

      final trix = ((ema3 / _previousTrix!) - 1) * 100;
      _previousTrix = ema3;

      _current = (value) {
        final ema1 = _ema1.current(value);
        final ema2 = ema1 != null ? _ema2.current(ema1) : null;
        final ema3 = ema2 != null ? _ema3.current(ema2) : null;
        return ema3 != null && _previousTrix != null ? ((ema3 / _previousTrix!) - 1) * 100 : null;
      };

      return trix;
    };

    _current = (_) => null;
  }

  /// Computes the next TRIX value based on the input value.
  double? next(double value) => _next(value);

  /// Computes the current TRIX value without affecting calculations.
  double? current(double value) => _current(value);
}
