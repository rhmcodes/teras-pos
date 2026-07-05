class LocalStorage {
  final Map<String, String> _storage = <String, String>{};

  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> read(String key) async {
    return _storage[key];
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
  }
}
