part of '../technical_indicators.dart';

/// **Average Directional Index (ADX)**
///
/// ADX measures the strength of a trend based on the values of +DI and -DI.
///
/// **Formula:**
/// ```
/// ADX = SMA((+DI - -DI) / (+DI + -DI))
/// ```
class ADX {
  final WWS _wma1; // ATR smoothing
  final WWS _wma2; // +DM smoothing
  final WWS _wma3; // -DM smoothing
  final WEMA _wema; // ADX smoothing

  double? _prevHigh;
  double? _prevLow;
  double? _prevClose;

  late Map<String, double?>? Function(double high, double low, double close) _next;
  late Map<String, double?>? Function(double high, double low, double close) _current;

  /// Constructs an ADX indicator with the specified [period].
  ADX([int period = 14])
      : _wma1 = WWS(period),
        _wma2 = WWS(period),
        _wma3 = WWS(period),
        _wema = WEMA(period) {
    _next = (high, low, close) {
      if (_prevClose == null) {
        _prevHigh = high;
        _prevLow = low;
        _prevClose = close;
        return null;
      }

      // Calculate True Range and directional movements
      final double trueRange = getTrueRange(high, low, _prevClose)!;
      final double hDiff = high - _prevHigh!;
      final double lDiff = _prevLow! - low;

      double pDM = 0;
      double nDM = 0;

      if (hDiff > lDiff && hDiff > 0) {
        pDM = hDiff;
      }

      if (lDiff > hDiff && lDiff > 0) {
        nDM = lDiff;
      }

      // Smooth the values
      final atr = _wma1.next(trueRange);
      final avgPDM = _wma2.next(pDM);
      final avgNDM = _wma3.next(nDM);

      _prevHigh = high;
      _prevLow = low;
      _prevClose = close;

      if (atr == null || avgPDM == null || avgNDM == null) return null;

      // Calculate +DI and -DI
      final double pDI = (avgPDM * 100) / atr;
      final double nDI = (avgNDM * 100) / atr;

      // Calculate DX and ADX
      final dx = ((pDI - nDI).abs() / (pDI + nDI)) * 100;

      return {'adx': _wema.next(dx), 'pdi': pDI, 'mdi': nDI};
    };

    _current = (high, low, close) {
      if (_prevClose == null) return null;

      final double trueRange = getTrueRange(high, low, _prevClose)!;
      final double hDiff = high - _prevHigh!;
      final double lDiff = _prevLow! - low;

      double pDM = 0;
      double nDM = 0;

      if (hDiff > lDiff && hDiff > 0) pDM = hDiff;
      if (lDiff > hDiff && lDiff > 0) nDM = lDiff;

      final atr = _wma1.current(trueRange);
      final avgPDM = _wma2.current(pDM);
      final avgNDM = _wma3.current(nDM);

      if (atr == null || avgPDM == null || avgNDM == null) return null;

      final pDI = (avgPDM * 100) / atr;
      final nDI = (avgNDM * 100) / atr;

      final dx = ((pDI - nDI).abs() / (pDI + nDI)) * 100;

      return {'adx': _wema.current(dx), 'pdi': pDI, 'mdi': nDI};
    };
  }

  /// Computes the next ADX value based on high, low, and close prices.
  Map<String, double?>? next(double high, double low, double close) => _next(high, low, close);

  /// Computes the current ADX value without affecting future calculations.
  Map<String, double?>? current(double high, double low, double close) => _current(high, low, close);
}
