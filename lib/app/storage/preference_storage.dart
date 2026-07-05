import 'local_storage.dart';

class PreferenceStorage {
  PreferenceStorage(this._localStorage);

  static const String _tokenKey = 'auth_token';

  final LocalStorage _localStorage;

  Future<void> saveToken(String token) {
    return _localStorage.write(_tokenKey, token);
  }

  Future<String?> getToken() {
    return _localStorage.read(_tokenKey);
  }

  Future<void> clearToken() {
    return _localStorage.delete(_tokenKey);
  }
}
