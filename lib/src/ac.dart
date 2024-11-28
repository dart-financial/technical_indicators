part of '../technical_indicators.dart';

/// **Accelerator Oscillator (AC)**
///
/// The Accelerator Oscillator measures the acceleration of momentum in the market.
/// It is calculated as the difference between the Awesome Oscillator (AO)
/// and a 5-period simple moving average of the AO.
///
/// **Formula:**
/// ```
/// AC = AO - SMA_5(AO)
/// ```
///
/// **Usage:**
/// - AC above 0 indicates acceleration to the upside.
/// - AC below 0 indicates acceleration to the downside.
/// - Look for changes in the AC direction for potential early trend shifts.
///
/// - **`next`:** Computes the next value based on high and low prices.
/// - **`current`:** Computes a momentary value without affecting future calculations.
class AC {
  final AO ao;
  final SMA sma;

  late double? Function(double high, double low) _next;
  late double? Function(double high, double low) _current;

  /// Constructs an Accelerator Oscillator with customizable AO and SMA periods.
  AC(int? period, {int aoFastPeriod = 5, int aoSlowPeriod = 34})
      : ao = AO(aoFastPeriod, aoSlowPeriod),
        sma = SMA(period ?? 5) {
    _next = (high, low) {
      final aoValue = ao.next(high, low);
      if (aoValue == null) {
        return null;
      }

      final smaValue = sma.next(aoValue);
      if (smaValue == null) {
        return null;
      }

      _next = (high, low) {
        final ao = this.ao.next(high, low)!;
        return ao - sma.next(ao)!;
      };

      _current = (high, low) {
        final ao = this.ao.current(high, low)!;
        return ao - sma.current(ao)!;
      };

      return aoValue - smaValue;
    };

    _current = (_, __) => null;
  }

  /// Computes the next AC value based on high and low prices.
  double? next(double high, double low) => _next(high, low);

  /// Computes a momentary AC value without affecting internal calculations.
  double? current(double high, double low) => _current(high, low);
}
