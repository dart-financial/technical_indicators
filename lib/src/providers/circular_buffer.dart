// class CircularBuffer {
//   bool filled = false;
//   int pointer = 0;
//   late List<double?> buffer;
//   late int maxIndex;

//   CircularBuffer(int length) {
//     buffer = List<double?>.filled(length, null);
//     maxIndex = length - 1;
//   }

//   /// Push item to buffer, when buffer length is overflow, push will rewrite oldest item
//   double? push(double item) {
//     buffer.removeLast();
//     final double? overwritten = buffer[pointer];
//     buffer[pointer] = item;
//     moveNext();
//     return overwritten;
//   }

//   /// Replace last added item in buffer (reversal push). May be used for revert push removed item.
//   @Deprecated('use peek instead')
//   double? pushback(double item) {
//     movePrevious();
//     final double? overwritten = buffer[pointer];
//     buffer[pointer] = item;
//     return overwritten;
//   }

//   /// Get item for replacing, does not modify anything
//   double? peek() {
//     return buffer[pointer];
//   }

//   /// Array like forEach loop
//   void forEach(void Function(double? value, int index) callback) {
//     int virtualIdx = 0;

//     for (final element in buffer) {
//       callback(element, virtualIdx);
//       virtualIdx++;
//     }
//   }

//   /// Array like forEach loop, but from last to first (reversal forEach)
//   void forEachReversed(void Function(double? value, int index) callback) {
//     int virtualIdx = buffer.length - 1;

//     for (final element in buffer.reversed) {
//       callback(element, virtualIdx);
//       virtualIdx--;
//     }
//   }

//   /// Fill buffer
//   void fill(double item) {
//     buffer.fillRange(0, buffer.length, item);
//     filled = true;
//   }

//   /// Get array from buffer
//   List<double?> toList() {
//     return buffer;
//   }

//   /// Move iterator to next position
//   void moveNext() {
//     pointer++;
//     if (pointer > maxIndex) {
//       pointer = 0;
//       filled = true;
//     }
//   }

//   /// Move iterator to prev position
//   void movePrevious() {
//     pointer--;
//     if (pointer < 0) {
//       pointer = maxIndex;
//     }
//   }
// }

/// Circular buffers (also known as ring buffers) are fixed-size buffers that work as if the memory is contiguous & circular in nature.
/// As memory is generated and consumed, data does not need to be reshuffled – rather, the head/tail pointers are adjusted.
/// When data is added, the head pointer advances. When data is consumed, the tail pointer advances.
/// If you reach the end of the buffer, the pointers simply wrap around to the beginning.
class CircularBuffer<T> {
  final int capacity;
  final List<T?> _buffer;
  int _head = 0;
  int _size = 0;

  CircularBuffer(this.capacity) : _buffer = List<T?>.filled(capacity, null);

  bool get isFull => _size == capacity;
  bool get isEmpty => _size == 0;

  int get length => _size;

  /// Adiciona um novo elemento ao buffer, sobrescrevendo o mais antigo se cheio.
  T? push(T item) {
    final overwritten = _buffer[_head];
    _buffer[_head] = item;
    _advance();
    return overwritten;
  }

  /// Obtém o valor no índice atual sem avançar o ponteiro.
  T? peek() => _buffer[_head];

  /// Acessa um elemento em uma posição relativa ao `_head`.
  T? getAt(int offset) {
    if (offset < 0 || offset >= _size) return null;
    final index = (_head + offset) % capacity;
    return _buffer[index];
  }

  /// Retorna uma cópia dos itens do buffer em ordem.
  List<T?> toList() {
    return List<T?>.generate(_size, (i) => getAt(i));
  }

  /// Iteração com suporte a lógica circular.
  Iterable<T?> get iterable sync* {
    for (int i = 0; i < _size; i++) {
      yield getAt(i);
    }
  }

  void _advance() {
    _head = (_head + 1) % capacity;
    if (_size < capacity) _size++;
  }
}
