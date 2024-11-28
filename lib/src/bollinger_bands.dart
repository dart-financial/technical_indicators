part of '../technical_indicators.dart';

/// A data class to hold the Bollinger Bands results.
/// This includes the lower band, middle (SMA), and upper band.
class BollingerBandsData {
  /// The lower Bollinger Band.
  final double lower;

  /// The middle Bollinger Band (Simple Moving Average).
  final double middle;

  /// The upper Bollinger Band.
  final double upper;

  /// Constructs an immutable BollingerBandsData object.
  const BollingerBandsData(this.lower, this.middle, this.upper);
}

/// A class to compute Bollinger Bands, a technical analysis tool.
/// Bollinger Bands consist of:
/// - A middle band (Simple Moving Average - SMA).
/// - Upper and lower bands at a specified number of standard deviations
///   (stdDev) above and below the middle band.
class BollingerBands {
  /// The Standard Deviation calculator.
  final StandardDeviation sd;

  /// The Simple Moving Average calculator.
  final SMA sma;

  /// The period for the Bollinger Bands calculation.
  final int period;

  /// The number of standard deviations for the upper and lower bands.
  final double stdDev;

  /// Tracks the number of values added, used during initialization.
  int _fill = 0;

  /// Function to calculate the next Bollinger Bands values (affects the state).
  late BollingerBandsData? Function(double value) _next;

  /// Function to calculate the current Bollinger Bands values
  /// (does not affect the state).
  late BollingerBandsData? Function(double value) _current;

  /// Creates a BollingerBands instance with a specified period and standard deviation.
  ///
  /// [period]: The number of data points used for the SMA and Standard Deviation.
  /// [stdDev]: The number of standard deviations for the bands.
  BollingerBands([this.period = 20, this.stdDev = 2.0])
      : sma = SMA(period),
        sd = StandardDeviation(period) {
    /// Internal helper function to calculate Bollinger Bands values.
    BollingerBandsData calc(double middle, double sd) {
      final lower = middle - stdDev * sd;
      final upper = middle + stdDev * sd;
      return BollingerBandsData(lower, middle, upper);
    }

    // Initial behavior for the next() method during initialization.
    _next = (close) {
      final middle = this.sma.next(close);
      if (middle == null) {
        return null;
      }

      final sd = this.sd.next(close, middle);
      _fill++;

      // Wait until enough data points are added to fill the period.
      if (_fill < period) {
        return null;
      }

      // Redefine the methods after initialization is complete.
      _current = (close) {
        final middle = this.sma.current(close);
        if (middle == null) return null;

        final sd = this.sd.current(close, middle);

        return calc(middle, sd);
      };

      _next = (close) {
        final middle = this.sma.next(close);
        if (middle == null) return null;

        final sd = this.sd.next(close, middle);

        return calc(middle, sd);
      };

      return calc(middle, sd);
    };

    // Initial behavior for the current() method during initialization.
    _current = (_) => null;
  }

  /// Calculates the next Bollinger Bands values based on a new closing price.
  /// This method affects the internal state and recalculates the bands.
  ///
  /// [close]: The new closing price to include in the calculation.
  /// Returns a [BollingerBandsData] instance or `null` if the period is not yet filled.
  BollingerBandsData? next(double close) => _next(close);

  /// Calculates the current Bollinger Bands values without affecting the state.
  ///
  /// [close]: The hypothetical closing price to evaluate.
  /// Returns a [BollingerBandsData] instance or `null` if the period is not yet filled.
  BollingerBandsData? current(double close) => _current(close);
}
