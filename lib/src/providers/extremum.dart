import 'circular_buffer.dart';

typedef _Comparator<T> = bool Function(T a, T b);

class ExtremumProvider<T extends num> {
  final CircularBuffer _buffer;
  final _Comparator<T> _compare;
  T _extreme;

  ExtremumProvider(int period, this._compare, T Function() extremeInitial)
      : _buffer = CircularBuffer(period),
        _extreme = extremeInitial();

  bool get isFull => _buffer.isFull;

  T next(T value) {
    if (_compare(value, _extreme)) {
      _extreme = value;
    }

    final removed = _buffer.push(value);

    if (removed == _extreme && !_compare(_extreme, value)) {
      // Recalcula o extremo em caso de degradação
      _extreme = _buffer.iterable.whereType<T>().reduce((a, b) => _compare(a, b) ? a : b);
    }

    return _extreme;
  }

  T current(T value) {
    return _compare(_extreme, value) ? _extreme : value;
  }
}

class MinProvider extends ExtremumProvider<double> {
  MinProvider(int period) : super(period, (a, b) => a < b, () => double.infinity);
}

class MaxProvider extends ExtremumProvider<double> {
  MaxProvider(int period) : super(period, (a, b) => a > b, () => double.negativeInfinity);
}
