import 'package:app/models/user.dart';
import 'package:app/repositories/local_user_repository.dart';
import 'package:app/repositories/user_repository.dart';

class AppState {
  static late UserRepository userRepository;
  static User? activeUser;

  static Future<void> init() async {
    userRepository = LocalUserRepository();
    activeUser = await userRepository.getUser();
  }

  static Future<void> saveUser(User user) async {
    await userRepository.saveUser(user);
    activeUser = user;
  }

  static Future<bool> login(String email, String password) async {
    final bool success = await userRepository.login(email, password);
    if (success) {
      activeUser = await userRepository.getUser();
    }
    return success;
  }

  static Future<void> logout() async {
    await userRepository.logout();
    activeUser = null;
  }
}
