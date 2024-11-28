part of '../technical_indicators.dart';

/// **Awesome Oscillator (AO)**
///
/// The Awesome Oscillator (AO) is a momentum indicator that measures the market momentum
/// by calculating the difference between a fast (5-period) and a slow (34-period)
/// simple moving average (SMA) of the median price.
///
/// **Formula:**
/// ```
/// Median Price = (High + Low) / 2
/// AO = SMA_5(Median Price) - SMA_34(Median Price)
/// ```
///
/// - **Fast SMA:** A quick-moving 5-period SMA.
/// - **Slow SMA:** A slower-moving 34-period SMA.
///
/// **Usage:**
/// - AO above 0 indicates bullish momentum.
/// - AO below 0 indicates bearish momentum.
/// - Look for crossovers or divergences for trading signals.
///
/// - **`next`:** Computes the next value based on a new high and low price.
/// - **`current`:** Computes a momentary value without affecting internal calculations.
class AO {
  final SMA smaSlow;
  final SMA smaFast;

  late double? Function(double high, double low) _next;
  late double? Function(double high, double low) _current;

  /// Constructs an Awesome Oscillator with default periods of 5 and 34.
  AO([int fastPeriod = 5, int slowPeriod = 34])
      : smaSlow = SMA(slowPeriod),
        smaFast = SMA(fastPeriod) {
    _next = (high, low) {
      final median = (high + low) / 2;
      final slowValue = smaSlow.next(median);
      final fastValue = smaFast.next(median);

      if (slowValue == null || fastValue == null) return null;

      _next = (high, low) {
        final median = (high + low) / 2;
        return smaFast.next(median)! - smaSlow.next(median)!;
      };

      _current = (high, low) {
        final median = (high + low) / 2;
        return smaFast.current(median)! - smaSlow.current(median)!;
      };

      return fastValue - slowValue;
    };

    _current = (_, __) => null;
  }

  /// Computes the next AO value based on a closed candle's high and low prices.
  double? next(double high, double low) => _next(high, low);

  /// Computes a momentary AO value without affecting internal calculations.
  double? current(double high, double low) => _current(high, low);
}
