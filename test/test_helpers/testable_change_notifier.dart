import 'package:flutter/widgets.dart';

mixin TestableChangeNotifier on ChangeNotifier {
  final List<VoidCallback> _listeners = <VoidCallback>[];
 List<VoidCallback> get Listeners => _listeners;


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _listeners.add(listener);
  }

  @override
  void notifyListeners() {
    if (hasListeners) {
      super.notifyListeners();
    }
  }
}
