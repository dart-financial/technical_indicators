part of '../technical_indicators.dart';

/// **Exponentially Weighted Moving Average (EWMA)**
///
/// The EWMA is a moving average that assigns exponentially decreasing weights
/// to older observations. It is commonly used in finance and statistics
/// for modeling time series and detecting volatility.
///
/// **Formula:**
/// ```
/// EWMA = α * Current Value + (1 - α) * Previous EWMA
/// ```
///
/// **Usage:**
/// - Alpha (α): Determines the weight of the current observation (0 < α ≤ 1).
/// - Higher α values make the EWMA more responsive to recent changes.
///
/// - **`next`:** Computes the next EWMA value based on a new input.
/// - **`current`:** Computes a momentary EWMA value without affecting the internal state.
class EWMA implements MovingAverage {
  late double? Function(double value) _next;
  late double? Function(double value) _current;

  double? prevValue;

  /// Constructs an Exponentially Weighted Moving Average with a specified [alpha].
  /// Alpha must be in the range (0, 1].
  EWMA([double alpha = 0.2]) {
    double? prevValue;

    _next = (value) {
      prevValue ??= value;

      _current = (value) {
        return alpha * value + (1 - alpha) * prevValue!;
      };

      _next = (value) {
        prevValue = _current(value);
        return prevValue;
      };
      return null;
    };

    _current = (_) => null;
  }

  @override
  double? next(double value) => _next(value);

  @override
  double? current(double value) => _current(value);
}
