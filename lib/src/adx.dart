part of '../technical_indicators.dart';

/// **Average Directional Index (ADX)**
///
/// ADX measures the strength of a trend based on the values of +DI and -DI.
///
/// **Formula:**
/// ```
/// ADX = SMA((+DI - -DI) / (+DI + -DI))
/// ```
class ADX {
  final DMI _dmi;
  final SMA _sma;

  late double? Function(double high, double low, double close) _next;
  late double? Function(double high, double low, double close) _current;

  /// Constructs an ADX indicator with the specified [period].
  ADX({int period = 14})
      : _dmi = DMI(period: period),
        _sma = SMA(period) {
    _next = (high, low, close) {
      final dmi = _dmi.next(high, low, close);
      if (dmi == null) return null;

      final dx = ((dmi['+DI']! - dmi['-DI']!).abs() / (dmi['+DI']! + dmi['-DI']!)) * 100;
      return _sma.next(dx);
    };

    _current = (high, low, close) {
      final dmi = _dmi.current(high, low, close);
      if (dmi == null) return null;

      final dx = ((dmi['+DI']! - dmi['-DI']!).abs() / (dmi['+DI']! + dmi['-DI']!)) * 100;
      return _sma.current(dx);
    };
  }

  /// Computes the next ADX value based on high, low, and close prices.
  double? next(double high, double low, double close) => _next(high, low, close);

  /// Computes the current ADX value without affecting future calculations.
  double? current(double high, double low, double close) => _current(high, low, close);
}
