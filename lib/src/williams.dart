part of '../technical_indicators.dart';

/// Williams %R (Williams Percent Range)
///
/// Williams %R is a momentum indicator that measures overbought and oversold levels.
/// It fluctuates between 0 and -100, where values close to 0 indicate overbought levels
/// and values close to -100 indicate oversold levels.
///
/// Formula:
/// ```
/// Williams %R = ((Highest High - Close) / (Highest High - Lowest Low)) * -100
/// ```
///
/// - [next] computes the next Williams %R value based on a closed candle.
/// - [current] computes a momentary value without affecting future calculations.
class WilliamsR {
  final CircularBuffer<double> highs;
  final CircularBuffer<double> lows;

  late double? Function(double high, double low, double close) _next;
  late double? Function(double high, double low, double close) _current;

  /// Constructs a Williams %R indicator with a specified [period].
  WilliamsR([int period = 14])
      : highs = CircularBuffer<double>(period),
        lows = CircularBuffer<double>(period) {
    // Initial _next function before the buffer is full
    _next = (high, low, close) {
      highs.push(high);
      lows.push(low);

      if (highs.isFull && lows.isFull) {
        // Redefine _next after initialization
        _next = (high, low, close) {
          highs.push(high);
          lows.push(low);

          final highestHigh = highs.toList().reduce((a, b) => a! > b! ? a : b);
          final lowestLow = lows.toList().reduce((a, b) => a! < b! ? a : b);

          return _calculate(highestHigh!, lowestLow!, close);
        };

        // Define _current for momentary calculations
        _current = (high, low, close) {
          final highestHigh = highs.toList().reduce((a, b) => a! > b! ? a : b);
          final lowestLow = lows.toList().reduce((a, b) => a! < b! ? a : b);

          return _calculate(highestHigh!, lowestLow!, close);
        };

        final highestHigh = highs.toList().reduce((a, b) => a! > b! ? a : b);
        final lowestLow = lows.toList().reduce((a, b) => a! < b! ? a : b);

        return _calculate(highestHigh!, lowestLow!, close);
      }

      return null;
    };

    // Initial _current function before initialization
    _current = (_, __, ___) => null;
  }

  /// Computes the next Williams %R value based on a closed candle.
  ///
  /// This affects internal calculations and should only be used with confirmed data.
  ///
  /// - [high] High price of the candle.
  /// - [low] Low price of the candle.
  /// - [close] Closing price of the candle.
  double? next(double high, double low, double close) => _next(high, low, close);

  /// Computes a momentary Williams %R value without affecting internal calculations.
  ///
  /// This is useful for calculating values on partially completed candles or live data.
  ///
  /// - [high] High price of the candle.
  /// - [low] Low price of the candle.
  /// - [close] Closing price of the candle.
  double? current(double high, double low, double close) => _current(high, low, close);

  /// Internal calculation for Williams %R
  double _calculate(double highestHigh, double lowestLow, double close) {
    return ((highestHigh - close) / (highestHigh - lowestLow)) * -100;
  }
}
