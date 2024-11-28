part of '../technical_indicators.dart';

/// **Displaced Moving Average (DMA)**
///
/// DMA is a moving average shifted by a specified number of periods (displacement).
///
/// **Formula:**
/// ```
/// DMA = SMA(n) shifted by k periods
/// ```
class DMA {
  final SMA _sma;
  final CircularBuffer<double> _displacementBuffer;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  /// Constructs a DMA with the specified [period] and [displacement].
  DMA(int period, int displacement)
      : _sma = SMA(period),
        _displacementBuffer = CircularBuffer<double>(displacement) {
    _next = (value) {
      final smaValue = _sma.next(value);
      if (smaValue == null) {
        return null;
      }

      final displaced = _displacementBuffer.push(smaValue);
      return displaced;
    };

    _current = (_) => null;
  }

  /// Computes the next DMA value based on the input value.
  double? next(double value) => _next(value);

  /// Computes the current DMA value without affecting calculations.
  double? current(double value) => _current(value);
}
