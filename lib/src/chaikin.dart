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

  late double? Function(double high, double low, double close, double volume) _next;
  late double? Function(double high, double low, double close, double volume) _current;

  ChaikinOscillator([int fastPeriod = 3, int slowPeriod = 10])
      : emaFast = EMA(fastPeriod),
        emaSlow = EMA(slowPeriod) {
    _next = (high, low, close, volume) {
      final mfMultiplier = ((close - low) - (high - close)) / (high - low);
      _adl += mfMultiplier * volume;

      final emaFast = this.emaFast.next(_adl);
      final emaSlow = this.emaSlow.next(_adl);

      if (emaFast == null || emaSlow == null) {
        return null;
      }

      _next = (high, low, close, volume) {
        final mfMultiplier = ((close - low) - (high - close)) / (high - low);
        _adl += mfMultiplier * volume;

        return this.emaFast.next(_adl)! - this.emaSlow.next(_adl)!;
      };

      _current = (high, low, close, volume) {
        final mfMultiplier = ((close - low) - (high - close)) / (high - low);
        final adlTemp = _adl + mfMultiplier * volume;

        return this.emaFast.current(adlTemp)! - this.emaSlow.current(adlTemp)!;
      };

      return emaFast - emaSlow;
    };

    _current = (_, __, ___, ____) => null;
  }

  /// Computes the next Chaikin Oscillator value based on high, low, close, and volume.
  double? next(double high, double low, double close, double volume) => _next(high, low, close, volume);

  /// Computes a momentary Chaikin Oscillator value without affecting internal calculations.
  double? current(double high, double low, double close, double volume) => _current(high, low, close, volume);
}
