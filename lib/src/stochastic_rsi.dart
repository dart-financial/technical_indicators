part of '../technical_indicators.dart';

/// **Stochastic RSI**
///
/// The Stochastic RSI applies the Stochastics formula to RSI values rather than
/// raw price values. It measures the level of RSI relative to its high-low range
/// over a set time period, producing an oscillator that fluctuates between 0 and 100.
///
/// **Formula:**
/// ```
/// StochRSI = (RSI - Lowest RSI) / (Highest RSI - Lowest RSI) * 100
/// ```
///
/// **Usage:**
/// - StochRSI > 80: Indicates overbought conditions.
/// - StochRSI < 20: Indicates oversold conditions.
/// - Combines the benefits of RSI and Stochastics for momentum analysis.
///
/// - **`next`:** Computes the next Stochastic RSI value based on a closed candle.
/// - **`current`:** Computes a momentary Stochastic RSI value without affecting the internal state.
class StochasticRSI {
  final MaxProvider _max;
  final MinProvider _min;
  final RSI rsi;
  final SMA k;
  final SMA d;

  late Map<String, double>? Function(double value) _next;
  late Map<String, double>? Function(double value) _current;

  /// Constructs a Stochastic RSI with specified [rsiPeriod], [kPeriod], [dPeriod], and [stochPeriod].
  StochasticRSI({
    int rsiPeriod = 14,
    int kPeriod = 3,
    int dPeriod = 3,
    int stochPeriod = 14,
  })  : rsi = RSI(rsiPeriod),
        k = SMA(kPeriod),
        d = SMA(dPeriod),
        _max = MaxProvider(stochPeriod),
        _min = MinProvider(stochPeriod) {
    // Define o comportamento inicial
    _next = (close) {
      final rsi = this.rsi.next(close);

      if (rsi == null) {
        return null;
      }

      final max = _max.next(rsi);
      final min = _min.next(rsi);

      if (!_max.isFull || !_min.isFull) {
        return null;
      }

      final stochRsi = ((rsi - min) / (max - min)) * 100;

      final k = this.k.next(stochRsi);
      if (k == null) {
        return null;
      }

      final d = this.d.next(k);

      _current = (close) {
        final rsi = this.rsi.current(close);
        if (rsi == null) return null;

        final max = _max.current(rsi);
        final min = _min.current(rsi);

        final stochRsi = ((rsi - min) / (max - min)) * 100;
        final k = this.k.current(stochRsi);
        if (k == null) return null;

        final d = this.d.current(k);

        return {'k': k, 'd': d ?? 0.0, 'stochRsi': stochRsi};
      };

      _next = (close) {
        final rsi = this.rsi.next(close);
        if (rsi == null) return null;

        final max = _max.next(rsi);
        final min = _min.next(rsi);

        final stochRsi = ((rsi - min) / (max - min)) * 100;
        final k = this.k.next(stochRsi);
        if (k == null) return null;

        final d = this.d.next(k);

        return {'k': k, 'd': d ?? 0.0, 'stochRsi': stochRsi};
      };

      return {'k': k, 'd': d ?? 0.0, 'stochRsi': stochRsi};
    };

    _current = (_) => null;
  }

  /// Computes the next Stochastic RSI value for a closed candle.
  Map<String, double>? next(double value) => _next(value);

  /// Computes a momentary Stochastic RSI value for a non-closed candle.
  Map<String, double>? current(double value) => _current(value);
}
