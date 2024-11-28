// import { CircularBuffer } from './circular-buffer';
import 'dart:math' as math;

import 'circular_buffer.dart';

class StandardDeviation {
  final CircularBuffer<double> _values;

  late double Function(double value, double mean) _next;
  late double Function(double value, double mean) _current;

  StandardDeviation(int period) : _values = CircularBuffer<double>(period) {
    _next = (value, mean) {
      _values.push(value);
      return _calculateStandardDeviation(mean);
    };

    _current = (value, mean) {
      final removed = _values.push(value);
      final result = _calculateStandardDeviation(mean);
      _values.push(removed!); // Restore state
      return result;
    };
  }

  double _calculateStandardDeviation(double mean) {
    final squaredDiffs = _values.toList().map((v) => (v! - mean) * (v - mean));
    final variance = squaredDiffs.reduce((a, b) => a + b) / _values.capacity;
    return math.sqrt(variance);
  }

  double next(double value, double mean) => _next(value, mean);

  double current(double value, double mean) => _current(value, mean);

  // nextValue(value: number, mean?: number) {
  //     this.values.push(value);

  //     return Math.sqrt(this.values.toArray().reduce((acc, item) => acc + (item - mean) ** 2, 0) / this.period);
  // }

  // momentValue(value: number, mean?: number) {
  //     const rm = this.values.push(value);
  //     const result = Math.sqrt(
  //         this.values.toArray().reduce((acc, item) => acc + (item - mean) ** 2, 0) / this.period,
  //     );
  //     this.values.pushback(rm);

  //     return result;
  // }
}
