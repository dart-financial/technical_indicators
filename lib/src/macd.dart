part of '../technical_indicators.dart';

class MACDData {
  final double macd;
  final double? emaFast;
  final double? emaSlow;
  final double? signal;
  final double? histogram;

  const MACDData(
    this.macd,
    this.emaFast,
    this.emaSlow,
    this.signal,
    this.histogram,
  );
}

/// **Moving Average Convergence Divergence (MACD)**
///
/// The MACD is a trend-following momentum indicator that shows the relationship between
/// two moving averages of a security's price. It consists of the MACD line, Signal line,
/// and a Histogram representing the difference.
///
/// **Formula:**
/// ```
/// MACD Line = EMA_12 - EMA_26
/// Signal Line = EMA_9(MACD Line)
/// Histogram = MACD Line - Signal Line
/// ```
///
/// **Usage:**
/// - Histogram > 0: Bullish momentum.
/// - Histogram < 0: Bearish momentum.
/// - Signal crossovers and histogram reversals are key signals.
///
/// - **`next`:** Computes the next MACD value for a closed candle.
/// - **`current`:** Computes a momentary MACD value without modifying the internal state.
class MACD {
  late MACDData? Function(double value) _next;
  late MACDData? Function(double value) _current;

  /// Constructs a MACD indicator with customizable EMA periods.
  MACD([int fastPeriod = 12, int slowPeriod = 26, int signalPeriod = 9]) {
    final EMA fast = EMA(fastPeriod);
    final EMA slow = EMA(slowPeriod);
    final EMA signal = EMA(signalPeriod);

    _next = (value) {
      final emaFast = fast.next(value);
      final emaSlow = slow.next(value);

      if (emaFast == null || emaSlow == null) return null;

      // Redefine métodos após inicialização
      _next = (value) => _calculate(
            fast.next(value),
            slow.next(value),
            signal.next,
          );

      _current = (value) => _calculate(
            fast.current(value),
            slow.current(value),
            signal.current,
          );

      return _calculate(emaFast, emaSlow, signal.next);
    };

    _current = (_) => null;
  }

  /// Computes the next MACD value for a closed candle.
  MACDData? next(double value) => _next(value);

  /// Computes a momentary MACD value for a non-closed candle.
  MACDData? current(double value) => _current(value);

  /// Centralized calculation logic for MACD data.
  MACDData? _calculate(double? emaFast, double? emaSlow, double? Function(double) signalCalc) {
    if (emaFast == null || emaSlow == null) return null;

    final macd = emaFast - emaSlow;
    final signal = signalCalc(macd);
    final histogram = signal != null ? macd - signal : null;

    return MACDData(macd, emaFast, emaSlow, signal, histogram);
  }
}
