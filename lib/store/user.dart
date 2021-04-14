import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String _title = 'chaves';
  String get title => _title;

  void setUserName(String name) {
    _title = 'chaves' + name;
    notifyListeners();
  }
}
