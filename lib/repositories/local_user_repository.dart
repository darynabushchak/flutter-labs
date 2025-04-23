import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository implements UserRepository {
  static const _key = 'user_data';

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(user.toJson()));
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(jsonMap);
  }

  @override
  Future<bool> login(String email, String password) async {
    final user = await getUser();
    if (user == null) return false;
    return user.email == email && user.password == password;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
