part of '../technical_indicators.dart';

/// **Relative Strength Index (RSI)**
///
/// The Relative Strength Index (RSI) is a momentum oscillator that measures
/// the speed and change of price movements. It is used to identify overbought
/// or oversold conditions in a market.
///
/// **Formula:**
/// ```
/// RSI = 100 - (100 / (1 + RS))
/// RS = Average Gain / Average Loss
/// ```
///
/// **Usage:**
/// - RSI > 70: Overbought, possible trend reversal or pullback.
/// - RSI < 30: Oversold, possible upward correction.
/// - Can be combined with other indicators for confirmation.
///
/// - **`next`:** Computes the next RSI value based on a new input.
/// - **`current`:** Computes a momentary RSI value without modifying internal state.
class RSI {
  final AvgChangeProvider change;
  final int period;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a Relative Strength Index with a specified [period].
  RSI([this.period = 14]) : change = AvgChangeProvider(period) {
    _next = (value) {
      final (upAvg, downAvg) = change.next(value);

      if (upAvg != null && downAvg != null) {
        _next = (value) {
          final (upAvg, downAvg) = change.next(value);
          return 100 - 100 / (1 + (upAvg! / -downAvg!));
        };
        _current = (value) {
          final (upAvg, downAvg) = change.current(value);
          return 100 - 100 / (1 + (upAvg! / -downAvg!));
        };
        return 100 - 100 / (1 + (upAvg / -downAvg));
      }
      return null;
    };

    _current = (_) => null;
  }

  /// Computes the next RSI value based on a new input.
  double? next(double value) => _next(value);

  /// Computes a momentary RSI value without modifying internal state.
  double? current(double value) => _current(value);
}
