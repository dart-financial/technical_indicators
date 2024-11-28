part of '../technical_indicators.dart';

/// **Keltner Channels**
///
/// Keltner Channels use an Exponential Moving Average (EMA) as the central line
/// and the Average True Range (ATR) for the upper and lower bands.
///
/// **Formula:**
/// ```
/// Upper Band = EMA + (Multiplier × ATR)
/// Lower Band = EMA - (Multiplier × ATR)
/// ```
///
/// **Usage:**
/// - Indicates overbought and oversold levels.
/// - Useful for trend identification and volatility analysis.
///
/// - **`next`:** Computes the next channels based on high, low, and close prices.
/// - **`current`:** Computes the current channels without affecting future calculations.
class KeltnerChannels {
  final EMA _ema;
  final ATR _atr;
  final double multiplier;

  late Map<String, double>? Function(double high, double low, double close) _next;
  late Map<String, double>? Function(double high, double low, double close) _current;

  /// Constructs Keltner Channels with a specified [period] and [multiplier].
  KeltnerChannels({int period = 20, this.multiplier = 2.0})
      : _ema = EMA(period),
        _atr = ATR(period) {
    _next = (high, low, close) {
      final ema = _ema.next(close);
      final atr = _atr.next(high, low, close);

      if (ema == null || atr == null) {
        return null;
      }

      _next = (high, low, close) {
        final ema = _ema.next(close);
        final atr = _atr.next(high, low, close);
        return {
          'upper': ema! + multiplier * atr!,
          'lower': ema - multiplier * atr,
          'middle': ema,
        };
      };

      _current = (high, low, close) {
        final ema = _ema.current(close);
        final atr = _atr.current(high, low, close);
        return {
          'upper': ema! + multiplier * atr!,
          'lower': ema - multiplier * atr,
          'middle': ema,
        };
      };

      return {
        'upper': ema + multiplier * atr,
        'lower': ema - multiplier * atr,
        'middle': ema,
      };
    };

    _current = (_, __, ___) => null;
  }

  /// Computes the next Keltner Channels based on high, low, and close prices.
  Map<String, double>? next(double high, double low, double close) => _next(high, low, close);

  /// Computes the current Keltner Channels without affecting calculations.
  Map<String, double>? current(double high, double low, double close) => _current(high, low, close);
}
