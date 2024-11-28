part of '../technical_indicators.dart';

/// **Rate of Change (ROC)**
///
/// The Rate-of-Change (ROC) indicator, also known as Momentum, measures the percentage change
/// in price over a specified period. It oscillates around the zero line, with positive values
/// indicating upward momentum and negative values indicating downward momentum.
///
/// **Formula:**
/// ```
/// ROC = ((Current Price - Price n Periods Ago) / Price n Periods Ago) * 100
/// ```
///
/// **Usage:**
/// - Identifies momentum shifts and potential trend reversals.
/// - Centerline crossovers can signal trend direction.
/// - Useful for spotting overbought and oversold conditions.
///
/// - **`next`:** Computes the next ROC value based on a new input.
/// - **`current`:** Computes a momentary ROC value without modifying the internal state.
class ROC {
  final CircularBuffer buffer;
  final int period;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a Rate of Change (ROC) indicator with a specified [period].
  ROC([this.period = 5]) : buffer = CircularBuffer(period) {
    _next = (value) {
      final outed = buffer.push(value);
      if (outed != null) {
        _next = (value) {
          final outed = buffer.push(value);
          return ((value - outed!) / outed) * 100;
        };
        _current = (value) {
          final outed = buffer.peek();
          return ((value - outed!) / outed) * 100;
        };
        return ((value - outed) / outed) * 100;
      }
      return null;
    };

    _current = (_) => null;
  }

  /// Computes the next ROC value based on a new input.
  double? next(double value) => _next(value);

  /// Computes a momentary ROC value without modifying the internal state.
  double? current(double value) => _current(value);
}
