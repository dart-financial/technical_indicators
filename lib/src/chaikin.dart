part of '../technical_indicators.dart';

/// **Chaikin Oscillator**
///
/// The Chaikin Oscillator measures the momentum of the Accumulation/Distribution Line (ADL).
/// It is calculated as the difference between the 3-period and 10-period EMAs of the ADL.
///
/// **Formula:**
/// ```
/// ADL = Previous ADL + (((Close - Low) - (High - Close)) / (High - Low)) * Volume
/// Chaikin Oscillator = EMA_3(ADL) - EMA_10(ADL)
/// ```
///
/// **Usage:**
/// - Positive values indicate bullish pressure (buying).
/// - Negative values indicate bearish pressure (selling).
/// - Used to anticipate price movements based on volume momentum.
///
/// - **`next`:** Computes the next value based on high, low, close, and volume.
/// - **`current`:** Computes a momentary value without affecting future calculations.
class ChaikinOscillator {
  final EMA emaFast;
  final EMA emaSlow;

  double _adl = 0;

  late num? Function(double high, double low, double close, double volume) _next;
  late num? Function(double high, double low, double close, double volume) _current;

  ChaikinOscillator([int fastPeriod = 3, int slowPeriod = 10])
      : emaFast = EMA(fastPeriod),
        emaSlow = EMA(slowPeriod) {
    _next = (high, low, close, volume) {
      _adl += (close == high && close == low) || high == low ? 0 : ((2 * close - low - high) / (high - low)) * volume;

      final double? fast = emaFast.next(_adl);
      final double? slow = emaSlow.next(_adl);

      if (fast == null || slow == null) return null;

      _next = (high, low, close, volume) {
        _adl += (close == high && close == low) || high == low ? 0 : ((2 * close - low - high) / (high - low)) * volume;

        final val = emaFast.next(_adl)! - emaSlow.next(_adl)!;
        return val;
      };

      _current = (high, low, close, volume) {
        final double adl = _adl +
            ((close == high && close == low) || high == low ? 0 : ((2 * close - low - high) / (high - low)) * volume);

        return emaFast.current(adl)! - emaSlow.current(adl)!;
      };

      final val = fast - slow;

      return val;
    };

    _current = (_, __, ___, ____) => null;
  }

  /// Computes the next Chaikin Oscillator value based on high, low, close, and volume.
  num? next(double high, double low, double close, double volume) => _next(high, low, close, volume);

  /// Computes a momentary Chaikin Oscillator value without affecting internal calculations.
  num? current(double high, double low, double close, double volume) => _current(high, low, close, volume);
}
