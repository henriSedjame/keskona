
import 'dart:async';

class ItemViewNotifier {

  final StreamController<String> _itemSelected = StreamController.broadcast();

  Stream<String> get stream => _itemSelected.stream;

  void select(String id) {
    _itemSelected.add(id);
  }
  void dispose() => _itemSelected.close();
}