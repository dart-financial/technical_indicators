part of '../technical_indicators.dart';

/// **Volume Ratio (VR)**
///
/// Measures the proportion of up-volume relative to total volume over a period.
///
/// **Formula:**
/// ```
/// VR = (Volume Up / Total Volume) * 100
/// ```
class VR {
  final CircularBuffer<double> _volumes;
  final CircularBuffer<bool> _directions;

  late double? Function(double volume, bool isUp) _next;
  late double? Function(double volume, bool isUp) _current;

  /// Constructs a VR indicator with the specified [period].
  VR({int period = 14})
      : _volumes = CircularBuffer<double>(period),
        _directions = CircularBuffer<bool>(period) {
    _next = (volume, isUp) {
      _volumes.push(volume);
      _directions.push(isUp);

      if (_volumes.isFull) {
        final totalVolume = _volumes.toList().reduce((a, b) => a! + b!);
        final upVolume = _volumes
            .toList()
            .asMap()
            .entries
            .where((entry) => _directions.getAt(entry.key) == true)
            .map((entry) => entry.value)
            .reduce((a, b) => a! + b!);

        _current = (volume, isUp) {
          return (upVolume! / totalVolume!) * 100;
        };

        return (upVolume! / totalVolume!) * 100;
      }

      return null;
    };

    _current = (_, __) => null;
  }

  /// Computes the next VR value.
  double? next(double volume, bool isUp) => _next(volume, isUp);

  /// Computes the current VR value without affecting future calculations.
  double? current(double volume, bool isUp) => _current(volume, isUp);
}
