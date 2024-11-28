part of '../technical_indicators.dart';

/// **On-Balance Volume (OBV)**
///
/// OBV is a cumulative indicator that uses volume flow to predict price movements.
/// It adds volume on up days and subtracts it on down days.
///
/// **Formula:**
/// ```
/// OBV = Previous OBV + Volume (if Close > Previous Close)
///      Previous OBV - Volume (if Close < Previous Close)
///      Previous OBV (if Close == Previous Close)
/// ```
class OBV {
  double _obv = 0;
  double? _previousClose;

  late double? Function(double close, double volume) _next;
  late double? Function(double close, double volume) _current;

  /// Constructs an OBV indicator.
  OBV() {
    _next = (close, volume) {
      if (_previousClose == null) {
        _previousClose = close;
        return null;
      }

      if (close > _previousClose!) {
        _obv += volume;
      } else if (close < _previousClose!) {
        _obv -= volume;
      }

      _previousClose = close;

      _current = (close, volume) {
        if (close > _previousClose!) {
          return _obv + volume;
        } else if (close < _previousClose!) {
          return _obv - volume;
        }
        return _obv;
      };

      return _obv;
    };

    _current = (_, __) => null;
  }

  /// Computes the next OBV value based on the closing price and volume.
  double? next(double close, double volume) => _next(close, volume);

  /// Computes a momentary OBV value without affecting future calculations.
  double? current(double close, double volume) => _current(close, volume);
}
