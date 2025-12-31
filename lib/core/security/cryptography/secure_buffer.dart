import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

class SecureBuffer {
  final int size;
  late Pointer<Uint8> _ptr;
  bool _isCleared = false;

  SecureBuffer(this.size) {
    // Alokacja pamięci natywnej (poza Garbage Collectorem)
    _ptr = calloc<Uint8>(size);
  }

  /// Zwraca widok na pamięć jako Uint8List, aby łatwo na nim operować w Dart
  Uint8List get view => _ptr.asTypedList(size);

  /// Główna funkcja: Zerowanie i zwalnianie pamięci
  void dispose() {
    if (_isCleared) return;

    // Nadpisujemy pamięć zerami (odpowiednik natywnego memset)
    for (int i = 0; i < size; i++) {
      _ptr[i] = 0;
    }

    // Zwalniamy wskaźnik
    calloc.free(_ptr);
    _isCleared = true;
  }
}
