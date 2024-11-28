part of '../technical_indicators.dart';

/// **Wilder's Smoothed Moving Average (WEMA)**
///
/// The Wilder's Smoothed Moving Average (WEMA) is a variation of the Simple Moving Average (SMA),
/// designed to give more weight to recent prices while maintaining simplicity.
/// It is often used in technical analysis to identify trends and smooth price fluctuations.
///
/// **Formula:**
/// ```
/// WEMA = (Current Value - Previous WEMA) * (1 / Period) + Previous WEMA
/// ```
///
/// **Usage:**
/// - Identifies trend direction with less lag compared to SMA.
/// - Useful in calculating indicators such as RSI or ADX.
///
/// - **`next`:** Computes the next WEMA value based on a new input.
/// - **`current`:** Computes a momentary WEMA value without modifying the internal state.
class WEMA implements MovingAverage {
  final SMA sma;
  final double smooth;
  double? _value;

  /// Constructs a Wilder's Smoothed Moving Average with a specified [period].
  WEMA(int period, {SMA? sma})
      : sma = sma ?? SMA(period),
        smooth = 1 / period;

  /// Computes the next WEMA value for a closed candle.
  @override
  double? next(double value) {
    if (_value == null) {
      return _value = sma.next(value);
    }

    return (_value = (value - _value!) * smooth + _value!);
  }

  /// Computes a momentary WEMA value for a non-closed candle without modifying the internal state.
  @override
  double? current(double value) {
    if (_value == null) return sma.current(value);

    return (value - _value!) * smooth + _value!;
  }
}
