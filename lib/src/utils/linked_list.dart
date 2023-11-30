import 'package:meta/meta.dart';

abstract class LinkedListTerm<T extends LinkedListTerm<T>> {
  @mustCallSuper
  LinkedListTerm({
    this.prevTerm,
    this.nextTerm,
  });

  T? prevTerm;

  T? nextTerm;

  LinkedListTerm replaceSelf(T linkedListTerm) {
    prevTerm?.nextTerm = linkedListTerm;
    linkedListTerm.prevTerm = prevTerm;

    nextTerm?.prevTerm = linkedListTerm;
    linkedListTerm.nextTerm = nextTerm;

    return linkedListTerm;
  }

  void removeSelf() {
    prevTerm?.nextTerm = nextTerm;

    nextTerm?.prevTerm = prevTerm;

    return;
  }

  LinkedListTerm<T> getFirstTerm() {
    LinkedListTerm<T>? term = this;
    while (term?.prevTerm != null) {
      term = term?.prevTerm;
    }
    return term!;
  }

  LinkedListTerm<T> getLastTerm() {
    LinkedListTerm<T>? term = this;
    while (term?.nextTerm != null) {
      term = term?.nextTerm;
    }
    return term!;
  }
}
