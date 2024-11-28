part of '../technical_indicators.dart';

class HeikenAshiData {
  final double o;
  final double h;
  final double l;
  final double c;

  const HeikenAshiData(this.o, this.h, this.l, this.c);
}

/// **Heikin-Ashi Candlesticks**
///
/// Heikin-Ashi Candlesticks are derived from traditional Japanese candlesticks.
/// They aim to filter out market noise and provide a clearer view of the trend.
/// Instead of using raw price data, Heikin-Ashi uses averaged values for its calculations.
///
/// **Formulas:**
/// ```
/// HA-Close = (Open + High + Low + Close) / 4
/// HA-Open = (Previous HA-Open + Previous HA-Close) / 2
/// HA-High = Max(High, HA-Open, HA-Close)
/// HA-Low = Min(Low, HA-Open, HA-Close)
/// ```
///
/// **Usage:**
/// - Identifies trends and reversals with reduced noise.
/// - Can be combined with other indicators for confirmation.
///
/// - **`next`:** Computes the next Heikin-Ashi candlestick values.
/// - **`current`:** Computes momentary Heikin-Ashi candlestick values.
class HeikenAshi {
  double _prevOpen = 0;
  double _prevClose = 0;

  HeikenAshi();

  /// Computes the next Heikin-Ashi candlestick values for a closed candle.
  HeikenAshiData next(double o, double h, double l, double c) {
    final data = calculate(o, h, l, c);

    _prevClose = data.c;
    _prevOpen = data.o;

    return data;
  }

  /// Computes momentary Heikin-Ashi candlestick values for a non-closed candle.
  HeikenAshiData current(double o, double h, double l, double c) {
    return calculate(o, h, l, c);
  }

  /// Centralized calculation logic for Heikin-Ashi data.
  HeikenAshiData calculate(double o, double h, double l, double c) {
    c = (o + h + l + c) / 4;

    if (_prevOpen > 0) {
      o = (_prevOpen + _prevClose) / 2;
    }

    h = [h, o, c].reduce(math.max);
    l = [l, o, c].reduce(math.min);

    return HeikenAshiData(o, h, l, c);
  }
}
