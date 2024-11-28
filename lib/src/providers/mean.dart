import 'circular_buffer.dart';

class MeanDeviationProvider {
  final CircularBuffer<double> _values;
  final int period;

  late double? Function(double typicalPrice, double? average) _next;
  late double? Function(double typicalPrice, double? average) _current;

  MeanDeviationProvider(this.period) : _values = CircularBuffer<double>(period) {
    // Inicializa os métodos de cálculo
    _next = (typicalPrice, average) {
      if (average == null) {
        _values.push(typicalPrice);
        return null;
      }

      // Redefine os métodos após a inicialização
      _next = _pureNext;
      _current = _pureCurrent;

      return _pureNext(typicalPrice, average);
    };

    _current = (_, __) => null;
  }

  double _pureNext(double typicalPrice, double? average) {
    _values.push(typicalPrice);

    return _values.toList().map((value) => _positiveDelta(average!, value!)).reduce((acc, delta) => acc + delta) /
        period;
  }

  double _pureCurrent(double typicalPrice, double? average) {
    final removed = _values.push(typicalPrice);

    final result =
        _values.toList().map((value) => _positiveDelta(average!, value!)).reduce((acc, delta) => acc + delta) / period;

    // Restaura o estado do buffer
    _values.push(removed!);

    return result;
  }

  double _positiveDelta(double a, double b) => (a - b).abs();

  double? next(double typicalPrice, double? average) => _next(typicalPrice, average);

  double? current(double typicalPrice, double? average) => _current(typicalPrice, average);
}
