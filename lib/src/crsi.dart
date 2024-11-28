part of '../technical_indicators.dart';

/// **Connors RSI (CRSI)**
///
/// Connors RSI (CRSI) is a momentum oscillator that generates a value between 0 and 100,
/// used primarily to identify overbought and oversold conditions.
///
/// **Key Levels:**
/// - CRSI > 90: Overbought
/// - CRSI < 10: Oversold
///
/// **Components:**
/// 1. RSI (Relative Strength Index) of the price.
/// 2. Up/Down Streak RSI: Measures consecutive gains or losses.
/// 3. Percent Rank of Rate of Change (ROC): Measures how recent price changes rank relative to the past.
///
/// **Usage:**
/// - CRSI generates buy/sell signals during trends or corrections.
/// - High CRSI indicates potential sell signals during uptrends.
/// - Low CRSI suggests potential buy signals during downtrends.
///
/// **Resources:**
/// Original concept: [TradingView Script](https://tradingview.com/script/vWAPUAl9-Stochastic-Connors-RSI/)
///
/// - **`next`:** Computes the next CRSI value for closed data.
/// - **`current`:** Computes a momentary CRSI value without affecting internal state.
class CRSI {
  final RSI _rsi;
  final RSI _updownRsi;
  final ROC _roc;
  final PercentRank _percentRank;

  double _prevClose = 0.0;
  int _updownPeriod = 0;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a Connors RSI indicator with specified [period], [updownRsiPeriod], and [percentRankPeriod].
  CRSI({
    int period = 3,
    int updownRsiPeriod = 2,
    int percentRankPeriod = 100,
  })  : _rsi = RSI(period),
        _updownRsi = RSI(updownRsiPeriod),
        _roc = ROC(1),
        _percentRank = PercentRank(percentRankPeriod) {
    _next = (value) {
      final rsi = _rsi.next(value);
      final rocValue = _roc.next(value);
      final percentRank = _percentRank.next(rocValue!);

      _updownPeriod = _getUpdownPeriod(value);
      _prevClose = value;
      final updownValue = _updownRsi.next(_updownPeriod.toDouble());

      if (rsi == null || percentRank == null || updownValue == null) {
        return null;
      }

      // Update `_current` behavior once initialization is complete.
      _current = (value) {
        final rsi = _rsi.current(value);
        final rocValue = _roc.current(value);
        final percentRank = _percentRank.current(rocValue!);

        final updownPeriod = _getUpdownPeriod(value);
        final updownValue = _updownRsi.current(updownPeriod.toDouble());

        if (rsi == null || percentRank == null || updownValue == null) {
          return null;
        }

        return (rsi + percentRank + updownValue) / 3;
      };

      // Redefine `_next` to avoid recalculating initialization logic.
      _next = (value) {
        final rsi = _rsi.next(value);
        final rocValue = _roc.next(value);
        final percentRank = _percentRank.next(rocValue!);

        _updownPeriod = _getUpdownPeriod(value);
        _prevClose = value;
        final updownValue = _updownRsi.next(_updownPeriod.toDouble());

        if (rsi == null || percentRank == null || updownValue == null) {
          return null;
        }

        return (rsi + percentRank + updownValue) / 3;
      };

      return (rsi + percentRank + updownValue) / 3;
    };

    _current = (_) => null;
  }

  /// Computes the next CRSI value for closed data and updates internal state.
  double? next(double value) => _next(value);

  /// Computes a momentary CRSI value for non-closed data without modifying internal state.
  double? current(double value) => _current(value);

  /// Calculates the up/down streak for a given value compared to the previous close.
  int _getUpdownPeriod(double value) {
    if (value > _prevClose) {
      return _updownPeriod < 0 ? 1 : _updownPeriod + 1;
    } else if (value < _prevClose) {
      return _updownPeriod > 0 ? -1 : _updownPeriod - 1;
    } else {
      return 0;
    }
  }
}
