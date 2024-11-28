// ignore_for_file: constant_identifier_names

part of '../technical_indicators.dart';

enum Smoothing {
  SMA,
  EMA,
  SMMA,
  WEMA,
  LWMA,
  EWMA,
  RMA,
}

/// **Average True Range (ATR)**
///
/// The Average True Range (ATR) is a volatility indicator that measures the degree of price movement
/// over a specified period. It provides insights into the market's volatility.
///
/// **Formula:**
/// ```
/// TR = Max(High - Low, |High - Previous Close|, |Low - Previous Close|)
/// ATR = Moving Average of True Range over Period
/// ```
///
/// **Usage:**
/// - High ATR: Indicates increased market volatility.
/// - Low ATR: Suggests reduced market volatility.
/// - Often used to set stop-loss levels and identify potential breakouts.
///
/// **Smoothing Options:**
/// - ATR supports multiple smoothing methods, such as SMA, EMA, WEMA, etc.
///
/// - **`next`:** Computes the next ATR value based on new inputs.
/// - **`current`:** Computes a momentary ATR value without affecting the internal state.
class ATR {
  late final MovingAverage _avg;
  double? _prevClose;

  /// Constructs an Average True Range with a specified [period] and [smoothing] method.
  ATR(int period, {Smoothing smoothing = Smoothing.WEMA}) {
    switch (smoothing) {
      case Smoothing.SMA:
        _avg = SMA(period);
      case Smoothing.EMA:
        _avg = EMA(period);
      case Smoothing.SMMA:
        _avg = SMMA(period);
      case Smoothing.WEMA:
        _avg = WEMA(period);
      case Smoothing.LWMA:
        _avg = LWMA(period);
      case Smoothing.EWMA:
        _avg = EWMA(0.2);
      case Smoothing.RMA:
        _avg = RMA(period);
    }
  }

  /// Computes the next ATR value for a closed candle.
  double? next(double high, double low, double close) {
    final tr = getTrueRange(high, low, _prevClose);
    _prevClose = close;
    if (tr == null) return null;
    return _avg.next(tr);
  }

  /// Computes a momentary ATR value for a non-closed candle.
  double? current(double high, double low, double close) {
    final tr = getTrueRange(high, low, _prevClose);
    if (tr == null) return null;
    return _avg.current(tr);
  }
}
