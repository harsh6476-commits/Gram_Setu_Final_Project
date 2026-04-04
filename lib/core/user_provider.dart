import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _role;

  Map<String, dynamic>? get user => _user;
  String? get role => _role;

  void setUser(Map<String, dynamic> user, [String? role]) {
    _user = user;
    _role = role ?? user['role'];
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _role = null;
    notifyListeners();
  }
}
