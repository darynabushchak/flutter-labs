import 'package:app/models/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);

  Future<User?> getUser();

  Future<bool> login(String email, String password);

  Future<void> logout();
}
