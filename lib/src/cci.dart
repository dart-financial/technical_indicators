part of '../technical_indicators.dart';

/// Commodity Channel Index (CCI)
///
/// The Commodity Channel Index (CCI) is a momentum-based oscillator that measures the deviation
/// of the price from its average over a specified period. It is commonly used to identify overbought
/// and oversold levels, as well as potential reversals.
///
/// Formula:
/// ```
/// Typical Price = (High + Low + Close) / 3
/// Mean Deviation = Average of Absolute Differences Between Typical Price and Moving Average
/// CCI = (Typical Price - Average) / (0.015 * Mean Deviation)
/// ```
///
/// - [next] computes the next CCI value based on a closed candle.
/// - [current] computes a momentary CCI value without affecting future calculations.
class CCI {
  final MeanDeviationProvider md;
  final SMA sma;

  final int period;

  late double? Function(double high, double low, double close) _next;
  late double? Function(double high, double low, double close) _current;

  CCI({this.period = 20})
      : md = MeanDeviationProvider(period),
        sma = SMA(period) {
    _next = (high, low, close) {
      final typicalPrice = (high + low + close) / 3;
      final average = sma.next(typicalPrice);
      final meanDeviation = md.next(typicalPrice, average);

      if (average == null || meanDeviation == null) return null;

      _next = (high, low, close) {
        final typicalPrice = (high + low + close) / 3;
        final average = sma.next(typicalPrice);
        final meanDeviation = md.next(typicalPrice, average);
        return (typicalPrice - average!) / (0.015 * meanDeviation!);
      };

      _current = (high, low, close) {
        final typicalPrice = (high + low + close) / 3;
        final average = sma.current(typicalPrice);
        final meanDeviation = md.current(typicalPrice, average);
        return (typicalPrice - average!) / (0.015 * meanDeviation!);
      };

      return (typicalPrice - average) / (0.015 * meanDeviation);
    };

    _current = (high, low, close) => null;
  }

  /// Computes the next CCI value based on a closed candle.
  ///
  /// This affects internal calculations and should only be used with confirmed data.
  ///
  /// - [high] High price of the candle.
  /// - [low] Low price of the candle.
  /// - [close] Closing price of the candle.
  double? next(double high, double low, double close) => _next(high, low, close);

  /// Computes a momentary CCI value without affecting internal calculations.
  ///
  /// This is useful for calculating values on partially completed candles or live data.
  ///
  /// - [high] High price of the candle.
  /// - [low] Low price of the candle.
  /// - [close] Closing price of the candle.
  double? current(double high, double low, double close) => _current(high, low, close);
}
