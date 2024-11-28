part of '../technical_indicators.dart';

/// **Stochastic Oscillator**
///
/// The Stochastic Oscillator is a momentum indicator that compares the closing price
/// of a security to the range of its prices over a specified period of time.
/// It generates overbought and oversold signals using a scale from 0 to 100.
///
/// **Formula:**
/// ```
/// %K = (Close - Lowest Low) / (Highest High - Lowest Low) * 100
/// ```
///
/// **Usage:**
/// - **Overbought Condition:** %K > 80
///   Indicates that the price is overbought and may reverse downward.
/// - **Oversold Condition:** %K < 20
///   Indicates that the price is oversold and may reverse upward.
/// - Often combined with %D (SMA of %K) for signal crossovers.
///
/// **Methods:**
/// - **`next`:** Computes the next Stochastic Oscillator value for a closed candle.
/// - **`current`:** Computes a momentary Stochastic Oscillator value for a non-closed candle.
class Stochastic {
  final int period;
  final CircularBuffer<double> _highBuffer;
  final CircularBuffer<double> _lowBuffer;

  late double? Function(double close, double high, double low) _next;
  late double? Function(double close, double high, double low) _current;

  /// Constructs a Stochastic Oscillator with a specified [period].
  Stochastic(this.period)
      : _highBuffer = CircularBuffer(period),
        _lowBuffer = CircularBuffer(period) {
    _next = (close, high, low) {
      _highBuffer.push(high);
      _lowBuffer.push(low);

      if (!_highBuffer.isFull || !_lowBuffer.isFull) {
        return null;
      }

      _current = _calculateCurrent;
      _next = _calculateNext;

      return _calculateNext(close, high, low);
    };

    _current = (_, __, ___) => null;
  }

  /// Computes the next Stochastic Oscillator value for a closed candle.
  double? next(double close, double high, double low) => _next(close, high, low);

  /// Computes a momentary Stochastic Oscillator value for a non-closed candle.
  double? current(double close, double high, double low) => _current(close, high, low);

  /// Calculates the Stochastic Oscillator value for a closed candle.
  double _calculateNext(double close, double high, double low) {
    final highestHigh = _highBuffer.iterable.reduce((a, b) => a! > b! ? a : b)!;
    final lowestLow = _lowBuffer.iterable.reduce((a, b) => a! < b! ? a : b)!;

    return ((close - lowestLow) / (highestHigh - lowestLow)) * 100;
  }

  /// Calculates a momentary Stochastic Oscillator value for non-closed data.
  double _calculateCurrent(double close, double high, double low) {
    final tempHighBuffer = _highBuffer.toList()..last = high;
    final tempLowBuffer = _lowBuffer.toList()..last = low;

    final highestHigh = tempHighBuffer.reduce((a, b) => a! > b! ? a : b)!;
    final lowestLow = tempLowBuffer.reduce((a, b) => a! < b! ? a : b)!;

    return ((close - lowestLow) / (highestHigh - lowestLow)) * 100;
  }
}
