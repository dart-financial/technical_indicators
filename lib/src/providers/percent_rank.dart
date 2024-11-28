import 'circular_buffer.dart';

/// Returns the percentile of a value. Returns the same values as the Excel PERCENTRANK and PERCENTRANK.INC functions.
class PercentRank {
  final CircularBuffer<double> _buffer;
  int _fill = 0;

  late double? Function(double value) _next;
  late double? Function(double value) _current;

  PercentRank(int period) : _buffer = CircularBuffer<double>(period) {
    _next = (value) {
      _buffer.push(value);
      _fill++;

      if (_fill >= period) {
        final result = _calc(value);

        // Redefinir os métodos após a inicialização
        _next = (value) {
          final result = _calc(value);
          _buffer.push(value);
          return result;
        };

        _current = _calc;
        return result;
      }

      return null;
    };

    _current = (_) => null; // Antes da inicialização
  }

  double? _calc(double value) {
    final items = _buffer.toList();
    int count = items.where((item) => item! <= value).length;
    return (count / _buffer.capacity) * 100;
  }

  double? next(double value) => _next(value);

  double? current(double value) => _current(value);

  // constructor(private period: number) {
  //   this.values = new CircularBuffer(period);
  // }
  // public nextValue(value: number) {
  //   this.values.push(value);
  //   this.fill++;
  //   if (this.fill === this.period) {
  //     this.nextValue = (value: number) => {
  //       const result = this.calc(value);
  //       this.values.push(value);
  //       return result;
  //     };
  //     this.momentValue = this.calc;
  //     return this.calc(value);
  //   }
  // }
  // public momentValue(value: number): number {
  //   return;
  // }
  // private calc(value: number) {
  //   let count = 0;
  //   this.values.toArray().forEach((item) => {
  //     if (item <= value) count++;
  //   });
  //   return (count / this.period) * 100;
  // }
}
