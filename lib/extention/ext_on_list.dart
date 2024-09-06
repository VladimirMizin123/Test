extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension ListExtension<T, Id> on List<T> {
  List<T> addBetweenItems(T item) {
    final items = <T>[];
    asMap().forEach((index, value) {
      if (index == length - 1) {
        items.add(value);
      } else {
        items.addAll([value, item]);
      }
    });
    return items;
  }
}
