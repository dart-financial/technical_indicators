part of '../technical_indicators.dart';

/// **Directional Movement Index (DMI)**
///
/// DMI measures the strength and direction of a trend using +DI, -DI, and ADX.
///
/// **Formula:**
/// ```
/// +DI = (SMA(+DM) / ATR) * 100
/// -DI = (SMA(-DM) / ATR) * 100
/// ADX = SMA((+DI - -DI) / (+DI + -DI))
/// ```
class DMI {
  final ATR _atr;
  final SMA _positiveDM;
  final SMA _negativeDM;
  final SMA _adx;

  final int period;

  late Map<String, double>? Function(double high, double low, double close) _next;
  late Map<String, double>? Function(double high, double low, double close) _current;

  /// Constructs a DMI indicator with the specified [period].
  DMI({this.period = 14})
      : _atr = ATR(period),
        _positiveDM = SMA(period),
        _negativeDM = SMA(period),
        _adx = SMA(period) {
    _next = (high, low, close) {
      final atr = _atr.next(high, low, close);
      if (atr == null) return null;

      double positiveDM = 0;
      double negativeDM = 0;

      if (high - low > 0) positiveDM = high - low;
      if (low - high > 0) negativeDM = low - high;

      final smoothedPositiveDM = _positiveDM.next(positiveDM);
      final smoothedNegativeDM = _negativeDM.next(negativeDM);

      if (smoothedPositiveDM == null || smoothedNegativeDM == null) return null;

      final plusDI = (smoothedPositiveDM / atr) * 100;
      final minusDI = (smoothedNegativeDM / atr) * 100;

      final dx = (plusDI - minusDI).abs() / (plusDI + minusDI) * 100;
      final adx = _adx.next(dx);

      _current = (high, low, close) {
        final atr = _atr.current(high, low, close);
        final double positiveDM = high - low > 0 ? high - low : 0;
        final double negativeDM = low - high > 0 ? low - high : 0;

        final smoothedPositiveDM = _positiveDM.current(positiveDM);
        final smoothedNegativeDM = _negativeDM.current(negativeDM);

        if (smoothedPositiveDM == null || smoothedNegativeDM == null || atr == null) return null;

        final plusDI = (smoothedPositiveDM / atr) * 100;
        final minusDI = (smoothedNegativeDM / atr) * 100;

        final dx = (plusDI - minusDI).abs() / (plusDI + minusDI) * 100;

        return {
          '+DI': plusDI,
          '-DI': minusDI,
          'ADX': _adx.current(dx) ?? 0,
        };
      };

      return {
        '+DI': plusDI,
        '-DI': minusDI,
        'ADX': adx ?? 0,
      };
    };

    _current = (_, __, ___) => null;
  }

  /// Computes the next DMI values (+DI, -DI, ADX) based on high, low, and close prices.
  Map<String, double>? next(double high, double low, double close) => _next(high, low, close);

  /// Computes the current DMI values without affecting future calculations.
  Map<String, double>? current(double high, double low, double close) => _current(high, low, close);
}
