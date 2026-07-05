class IdGenerator {
  const IdGenerator._();

  static String create(String prefix) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '$prefix-$timestamp';
  }
}
