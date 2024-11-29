import 'circular_buffer.dart';

/// Returns the percentile of a value. Returns the same values as the Excel PERCENTRANK and PERCENTRANK.INC functions.
class PercentRank {
  final CircularBuffer<double?> _buffer;
  int _fill = 0;

  late double? Function(double? value) _next;
  late double? Function(double? value) _current;

  PercentRank(int period) : _buffer = CircularBuffer<double?>(period) {
    _next = (value) {
      _buffer.push(value);
      _fill++;

      if (_fill >= period) {
        _current = _calc;
        // Redefinir os métodos após a inicialização
        _next = (value) {
          final result = _calc(value);
          _buffer.push(value);
          return result;
        };

        final result = _calc(value);
        return result;
      }

      return null;
    };

    _current = (_) => null; // Antes da inicialização
  }

  double? _calc(double? value) {
    // final items = _buffer.toList();
    // int count = items.where((item) => item! <= value).length;
    // return (count / _buffer.capacity) * 100;
    int count = 0;

    for (var e in _buffer.iterable) {
      if (e != null && value != null && e <= value) count++;
    }

    return (count / _buffer.capacity) * 100;
  }

  double? next(double? value) => _next(value);

  double? current(double? value) => _current(value);
}
