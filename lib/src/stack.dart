import 'dart:collection';

// Stack Data Structure implementation
class MyStack<T> {
  final _stack = Queue<T>();

  int get length => _stack.length;

  bool canPop() => _stack.isNotEmpty;

  void clearStack() {
    while (_stack.isNotEmpty) {
      _stack.removeLast();
    }
  }

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    if (canPop()) {
      var lastElement = _stack.last;
      _stack.removeLast();
      return lastElement;
    } else {
      print('Nothing left to pop');
      return null;
    }
  }

  T peak() => _stack.last;
}
