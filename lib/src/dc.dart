part of '../technical_indicators.dart';

class DonchianChannelsData {
  final double lower;
  final double middle;
  final double upper;

  const DonchianChannelsData(this.lower, this.middle, this.upper);
}

/// **Donchian Channels**
///
/// Donchian Channels identify the highest high and lowest low within a specified period,
/// forming upper, lower, and middle bands.
///
/// **Formula:**
/// ```
/// Upper Channel = Highest High (n)
/// Lower Channel = Lowest Low (n)
/// Middle Channel = (Upper Channel + Lower Channel) / 2
/// ```
///
/// **Usage:**
/// - Helps identify breakout levels.
/// - Useful for trend following and volatility analysis.
///
/// - **`next`:** Computes the next channels based on new high and low values.
/// - **`current`:** Computes the current channels without affecting future calculations.
class DonchianChannels {
  final MaxProvider _max;
  final MinProvider _min;

  late DonchianChannelsData? Function(double high, double low) _next;
  late DonchianChannelsData? Function(double high, double low) _current;

  /// Constructs Donchian Channels with a specified [period].
  DonchianChannels(int period)
      : _max = MaxProvider(period),
        _min = MinProvider(period) {
    _next = (high, low) {
      final upper = _max.next(high);
      final lower = _min.next(low);

      if (!_max.isFull || !_min.isFull) {
        return null;
      }

      _next = (high, low) {
        final upper = _max.next(high);
        final lower = _min.next(low);

        return DonchianChannelsData(lower, (upper + lower) / 2, upper);
      };

      _current = (high, low) {
        final upper = _max.current(high);
        final lower = _min.current(low);
        return DonchianChannelsData(lower, (upper + lower) / 2, upper);
      };

      return DonchianChannelsData(lower, (upper + lower) / 2, upper);
    };

    _current = (_, __) => null;
  }

  /// Computes the next Donchian Channels based on high and low values.
  DonchianChannelsData? next(double high, double low) => _next(high, low);

  /// Computes the current Donchian Channels without affecting calculations.
  DonchianChannelsData? current(double high, double low) => _current(high, low);
}
