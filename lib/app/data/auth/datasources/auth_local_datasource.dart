import '../models/app_user_model.dart';
import '../../local/local_pos_database.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._database);

  final LocalPosDatabase _database;

  Future<AppUserModel> login(String email, String password) {
    return _database.login(email, password);
  }

  Future<AppUserModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _database.register(name: name, email: email, password: password);
  }

  Future<void> forgotPassword(String email) {
    return _database.forgotPassword(email);
  }

  Future<void> logout() {
    return _database.logout();
  }

  Future<AppUserModel?> getCurrentUser() {
    return _database.getCurrentUser();
  }
}
