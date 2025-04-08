import 'package:app/models/user.dart';
import 'package:app/repositories/local_user_repository.dart';
import 'package:app/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = LocalUserRepository();
  User? _user;

  User? get user => _user;

  Future<void> init() async {
    _user = await _repository.getUser();
    notifyListeners();
  }

  Future<void> saveUser(User user) async {
    await _repository.saveUser(user);
    _user = user;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _repository.login(email, password);
    if (success) {
      _user = await _repository.getUser();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }
}
