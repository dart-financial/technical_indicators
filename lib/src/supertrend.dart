part of '../technical_indicators.dart';

/// **SuperTrend Indicator**
///
/// The SuperTrend indicator is a trend-following indicator that combines
/// price and volatility data to show the prevailing market trend.
/// It is calculated using the Average True Range (ATR) and a multiplier
/// to create upper and lower bands.
///
/// **Formula:**
/// ```
/// Mid Band = (High + Low) / 2
/// Upper Band = Mid Band + (Multiplier * ATR)
/// Lower Band = Mid Band - (Multiplier * ATR)
/// SuperTrend = Upper Band or Lower Band, depending on trend
/// ```
///
/// **Usage:**
/// - When price closes above the Lower Band, the trend is bullish.
/// - When price closes below the Upper Band, the trend is bearish.
/// - Can be used as a dynamic stop-loss level.
///
/// - **`next`:** Computes the next SuperTrend value based on a closed candle.
/// - **`current`:** Computes a momentary SuperTrend value without affecting internal state.
class SuperTrend {
  final int period;
  final double multiplier;
  late double atr;
  late double? Function(double high, double low, double close) _next;
  late double? Function(double high, double low, double close) _current;
  late bool isBullTrend;
  late double upperBand;
  late double lowerBand;

  /// Constructs a SuperTrend indicator with a specified [period] and [multiplier].
  SuperTrend(this.period, this.multiplier) {
    final ATR atrCalc = ATR(period);
    isBullTrend = true;

    _next = (high, low, close) {
      atr = atrCalc.next(high, low, close)!;

      final midBand = (high + low) / 2;
      upperBand = midBand + multiplier * atr;
      lowerBand = midBand - multiplier * atr;

      _current = _calculateCurrent;
      _next = _calculateNext;

      return null;
    };

    _current = (_, __, ___) => null;
  }

  /// Computes the next SuperTrend value for a closed candle.
  double? next(double high, double low, double close) => _next(high, low, close);

  /// Computes a momentary SuperTrend value without modifying internal state.
  double? current(double high, double low, double close) => _current(high, low, close);

  double? _calculateNext(double high, double low, double close) {
    if (isBullTrend) {
      if (close < lowerBand) {
        isBullTrend = false;
      }
    } else {
      if (close > upperBand) {
        isBullTrend = true;
      }
    }

    return isBullTrend ? lowerBand : upperBand;
  }

  double? _calculateCurrent(double high, double low, double close) {
    return isBullTrend ? lowerBand : upperBand;
  }
}
